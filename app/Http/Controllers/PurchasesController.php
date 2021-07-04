<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\PurchasesExport;
use App\Mail\PurchaseMail;
use App\Models\PaymentPurchase;
use App\Models\Product;
use App\Models\ProductVariant;
use App\Models\product_warehouse;
use App\Models\Provider;
use App\Models\Purchase;
use App\Models\PurchaseDetail;
use App\Models\Role;
use App\Models\Setting;
use App\Models\Warehouse;
use App\utils\helpers;
use Carbon\Carbon;
use Twilio\Rest\Client as Client_Twilio;
use DB;
use PDF;

class PurchasesController extends BaseController
{

    //------------- Show ALL Purchases ----------\\

    public function index(request $request)
    {
        $this->authorizeForUser($request->user('api'), 'view', Purchase::class);
        $role = Auth::user()->roles()->first();
        $view_records = Role::findOrFail($role->id)->inRole('record_view');
        // How many items do you want to display.
        $perPage = $request->limit;
        $pageStart = \Request::get('page', 1);
        // Start displaying items from this number;
        $offSet = ($pageStart * $perPage) - $perPage;
        $order = $request->SortField;
        $dir = $request->SortType;
        $helpers = new helpers();
        // Filter fields With Params to retrieve
        $param = array(
            0 => 'like',
            1 => 'like',
            2 => '=',
            3 => 'like',
            4 => '=',
            5 => '=',
        );
        $columns = array(
            0 => 'Ref',
            1 => 'statut',
            2 => 'provider_id',
            3 => 'payment_statut',
            4 => 'warehouse_id',
            5 => 'date',
        );
        $data = array();
        $total = 0;

        // Check If User Has Permission View  All Records
        $Purchases = Purchase::with('facture', 'provider', 'warehouse')
            ->where('deleted_at', '=', null)
            ->where(function ($query) use ($view_records) {
                if (!$view_records) {
                    return $query->where('user_id', '=', Auth::user()->id);
                }
            });

        //Multiple Filter
        $Filtred = $helpers->filter($Purchases, $columns, $param, $request)
        // Search With Multiple Param
            ->where(function ($query) use ($request) {
                return $query->when($request->filled('search'), function ($query) use ($request) {
                    return $query->where('Ref', 'LIKE', "%{$request->search}%")
                        ->orWhere('statut', 'LIKE', "%{$request->search}%")
                        ->orWhere('GrandTotal', $request->search)
                        ->orWhere('payment_statut', 'like', "$request->search")
                        ->orWhere(function ($query) use ($request) {
                            return $query->whereHas('provider', function ($q) use ($request) {
                                $q->where('name', 'LIKE', "%{$request->search}%");
                            });
                        })
                        ->orWhere(function ($query) use ($request) {
                            return $query->whereHas('warehouse', function ($q) use ($request) {
                                $q->where('name', 'LIKE', "%{$request->search}%");
                            });
                        });
                });
            });

        $totalRows = $Filtred->count();
        $Purchases = $Filtred->offset($offSet)
            ->limit($perPage)
            ->orderBy($order, $dir)
            ->get();

        foreach ($Purchases as $Purchase) {

            $item['id'] = $Purchase->id;
            $item['date'] = $Purchase->date;
            $item['Ref'] = $Purchase->Ref;
            $item['warehouse_name'] = $Purchase['warehouse']->name;
            $item['discount'] = $Purchase->discount;
            $item['shipping'] = $Purchase->shipping;
            $item['statut'] = $Purchase->statut;
            $item['provider_id'] = $Purchase['provider']->id;
            $item['provider_name'] = $Purchase['provider']->name;
            $item['provider_email'] = $Purchase['provider']->email;
            $item['provider_tele'] = $Purchase['provider']->phone;
            $item['provider_code'] = $Purchase['provider']->code;
            $item['provider_adr'] = substr($Purchase['provider']->adresse, 0, 30);
            $item['GrandTotal'] = number_format($Purchase->GrandTotal, 2, '.', '');
            $item['paid_amount'] = number_format($Purchase->paid_amount, 2, '.', '');
            $item['due'] = number_format($Purchase->GrandTotal - $Purchase->paid_amount, 2, '.', '');
            $item['payment_status'] = $Purchase->payment_statut;

            $data[] = $item;
        }

        $suppliers = provider::where('deleted_at', '=', null)->get(['id', 'name']);
        $warehouses = Warehouse::where('deleted_at', '=', null)->get(['id', 'name']);

        return response()->json([
            'totalRows' => $totalRows,
            'purchases' => $data,
            'suppliers' => $suppliers,
            'warehouses' => $warehouses,
        ]);
    }

    //------ Store new Purchase -------------\\

    public function store(Request $request)
    {
        $this->authorizeForUser($request->user('api'), 'create', Purchase::class);

        request()->validate([
            'supplier_id' => 'required',
            'warehouse_id' => 'required',
        ]);

        \DB::transaction(function () use ($request) {
            $order = new Purchase;

            $order->date = $request->date;
            $order->Ref = $this->getNumberOrder();
            $order->provider_id = $request->supplier_id;
            $order->GrandTotal = $request->GrandTotal;
            $order->warehouse_id = $request->warehouse_id;
            $order->tax_rate = $request->tax_rate;
            $order->TaxNet = $request->TaxNet;
            $order->discount = $request->discount;
            $order->shipping = $request->shipping;
            $order->statut = $request->statut;
            $order->payment_statut = 'unpaid';
            $order->notes = $request->notes;
            $order->user_id = Auth::user()->id;

            $order->save();

            $data = $request['details'];
            foreach ($data as $key => $value) {
                $orderDetails[] = [
                    'purchase_id' => $order->id,
                    'quantity' => $value['quantity'],
                    'cost' => $value['Unit_cost'],
                    'TaxNet' => $value['tax_percent'],
                    'tax_method' => $value['tax_method'],
                    'discount' => $value['discount'],
                    'discount_method' => $value['discount_Method'],
                    'product_id' => $value['product_id'],
                    'product_variant_id' => $value['product_variant_id'],
                    'total' => $value['subtotal'],
                ];
                $unit = Product::with('unitPurchase')
                    ->where('id', $value['product_id'])
                    ->where('deleted_at', '=', null)
                    ->first();

                if ($order->statut == "received") {
                    if ($value['product_variant_id'] !== null) {
                        $product_warehouse = product_warehouse::where('deleted_at', '=', null)
                            ->where('warehouse_id', $order->warehouse_id)
                            ->where('product_id', $value['product_id'])
                            ->where('product_variant_id', $value['product_variant_id'])
                            ->first();

                        if ($unit && $product_warehouse) {
                            if ($unit['unitPurchase']->operator == '/') {
                                $product_warehouse->qte += $value['quantity'] / $unit['unitPurchase']->operator_value;
                            } else {
                                $product_warehouse->qte += $value['quantity'] * $unit['unitPurchase']->operator_value;
                            }
                            $product_warehouse->save();
                        }

                    } else {
                        $product_warehouse = product_warehouse::where('deleted_at', '=', null)
                            ->where('warehouse_id', $order->warehouse_id)
                            ->where('product_id', $value['product_id'])
                            ->first();

                        if ($unit && $product_warehouse) {
                            if ($unit['unitPurchase']->operator == '/') {
                                $product_warehouse->qte += $value['quantity'] / $unit['unitPurchase']->operator_value;
                            } else {
                                $product_warehouse->qte += $value['quantity'] * $unit['unitPurchase']->operator_value;
                            }
                            $product_warehouse->save();
                        }
                    }
                }
            }
            PurchaseDetail::insert($orderDetails);
        }, 10);

        return response()->json(['success' => true, 'message' => 'Purchase Created !!']);
    }

    //--------- Update Purchase  -------------\\

    public function update(Request $request, $id)
    {
        $this->authorizeForUser($request->user('api'), 'update', Purchase::class);

        request()->validate([
            'warehouse_id' => 'required',
            'supplier_id' => 'required',
        ]);

        \DB::transaction(function () use ($request, $id) {
            $role = Auth::user()->roles()->first();
            $view_records = Role::findOrFail($role->id)->inRole('record_view');
            $current_Purchase = Purchase::findOrFail($id);

            // Check If User Has Permission view All Records
            if (!$view_records) {
                // Check If User->id === Purchase->id
                $this->authorizeForUser($request->user('api'), 'check_record', $current_Purchase);
            }

            $old_purchase_details = PurchaseDetail::where('purchase_id', $id)->get();
            $new_purchase_details = $request['details'];
            $length = sizeof($new_purchase_details);

            // Get Ids for new Details
            $new_products_id = [];
            foreach ($new_purchase_details as $new_detail) {
                $new_products_id[] = $new_detail['id'];
            }

            // Init Data with old Parametre
            $old_products_id = [];
            foreach ($old_purchase_details as $key => $value) {
                $unit = Product::with('unitPurchase')
                    ->where('id', $value['product_id'])
                    ->where('deleted_at', '=', null)
                    ->first();

                $old_products_id[] = $value->id;
                if ($current_Purchase->statut == "received") {

                    if ($value['product_variant_id'] !== null) {
                        $product_warehouse = product_warehouse::where('deleted_at', '=', null)
                            ->where('warehouse_id', $current_Purchase->warehouse_id)
                            ->where('product_id', $value['product_id'])
                            ->where('product_variant_id', $value['product_variant_id'])
                            ->first();

                        if ($unit && $product_warehouse) {
                            if ($unit['unitPurchase']->operator == '/') {
                                $product_warehouse->qte -= $value['quantity'] / $unit['unitPurchase']->operator_value;
                            } else {
                                $product_warehouse->qte -= $value['quantity'] * $unit['unitPurchase']->operator_value;
                            }

                            $product_warehouse->save();
                        }

                    } else {
                        $product_warehouse = product_warehouse::where('deleted_at', '=', null)
                            ->where('warehouse_id', $current_Purchase->warehouse_id)
                            ->where('product_id', $value['product_id'])
                            ->first();

                        if ($unit && $product_warehouse) {
                            if ($unit['unitPurchase']->operator == '/') {
                                $product_warehouse->qte -= $value['quantity'] / $unit['unitPurchase']->operator_value;
                            } else {
                                $product_warehouse->qte -= $value['quantity'] * $unit['unitPurchase']->operator_value;
                            }

                            $product_warehouse->save();
                        }
                    }
                }

                // Delete Detail
                if (!in_array($old_products_id[$key], $new_products_id)) {
                    $PurchaseDetail = PurchaseDetail::findOrFail($value->id);
                    $PurchaseDetail->delete();
                }

            }

            // Update Data with New request
            foreach ($new_purchase_details as $key => $prod_detail) {
                $unit_prod = Product::with('unitPurchase')
                    ->where('id', $prod_detail['product_id'])
                    ->where('deleted_at', '=', null)
                    ->first();

                if ($request['statut'] == "received") {

                    if ($prod_detail['product_variant_id'] !== null) {
                        $product_warehouse = product_warehouse::where('deleted_at', '=', null)
                            ->where('warehouse_id', $request->warehouse_id)
                            ->where('product_id', $prod_detail['product_id'])
                            ->where('product_variant_id', $prod_detail['product_variant_id'])
                            ->first();

                        if ($unit_prod && $product_warehouse) {
                            if ($unit_prod['unitPurchase']->operator == '/') {
                                $product_warehouse->qte += $prod_detail['quantity'] / $unit_prod['unitPurchase']->operator_value;
                            } else {
                                $product_warehouse->qte += $prod_detail['quantity'] * $unit_prod['unitPurchase']->operator_value;
                            }

                            $product_warehouse->save();
                        }

                    } else {
                        $product_warehouse = product_warehouse::where('deleted_at', '=', null)
                            ->where('warehouse_id', $request->warehouse_id)
                            ->where('product_id', $prod_detail['product_id'])
                            ->first();

                        if ($unit_prod && $product_warehouse) {
                            if ($unit_prod['unitPurchase']->operator == '/') {
                                $product_warehouse->qte += $prod_detail['quantity'] / $unit_prod['unitPurchase']->operator_value;
                            } else {
                                $product_warehouse->qte += $prod_detail['quantity'] * $unit_prod['unitPurchase']->operator_value;
                            }

                            $product_warehouse->save();
                        }
                    }

                }

                $orderDetails['purchase_id'] = $id;
                $orderDetails['cost'] = $prod_detail['Unit_cost'];
                $orderDetails['TaxNet'] = $prod_detail['tax_percent'];
                $orderDetails['tax_method'] = $prod_detail['tax_method'];
                $orderDetails['discount'] = $prod_detail['discount'];
                $orderDetails['discount_method'] = $prod_detail['discount_Method'];
                $orderDetails['quantity'] = $prod_detail['quantity'];
                $orderDetails['product_id'] = $prod_detail['product_id'];
                $orderDetails['product_variant_id'] = $prod_detail['product_variant_id'];
                $orderDetails['total'] = $prod_detail['subtotal'];

                if (!in_array($prod_detail['id'], $old_products_id)) {
                    PurchaseDetail::Create($orderDetails);
                } else {
                    PurchaseDetail::where('id', $prod_detail['id'])->update($orderDetails);
                }
            }

            $due = $request['GrandTotal'] - $current_Purchase->paid_amount;
            if ($due === 0.0 || $due < 0.0) {
                $payment_statut = 'paid';
            } else if ($due != $request['GrandTotal']) {
                $payment_statut = 'partial';
            } else if ($due == $request['GrandTotal']) {
                $payment_statut = 'unpaid';
            }

            $current_Purchase->update([
                'date' => $request['date'],
                'provider_id' => $request['supplier_id'],
                'warehouse_id' => $request['warehouse_id'],
                'notes' => $request['notes'],
                'tax_rate' => $request['tax_rate'],
                'TaxNet' => $request['TaxNet'],
                'discount' => $request['discount'],
                'shipping' => $request['shipping'],
                'statut' => $request['statut'],
                'GrandTotal' => $request['GrandTotal'],
                'payment_statut' => $payment_statut,
            ]);

        }, 10);

        return response()->json(['success' => true, 'message' => 'Purchase Updated !!']);

    }

    //------ Delete Purchase -------------\\

    public function destroy(Request $request, $id)
    {
        $this->authorizeForUser($request->user('api'), 'delete', Purchase::class);

        \DB::transaction(function () use ($id, $request) {
            $role = Auth::user()->roles()->first();
            $view_records = Role::findOrFail($role->id)->inRole('record_view');
            $Purchase = Purchase::findOrFail($id);

            // Check If User Has Permission view All Records
            if (!$view_records) {
                // Check If User->id === Purchase->id
                $this->authorizeForUser($request->user('api'), 'check_record', $Purchase);
            }
            $Purchase->details()->delete();
            $Purchase->update([
                'deleted_at' => Carbon::now(),
            ]);

            PaymentPurchase::where('purchase_id', $id)->update([
                'deleted_at' => Carbon::now(),
            ]);

        }, 10);
        return response()->json(['success' => true, 'message' => 'Purchase Deleted !!']);
    }

    //-------------- Delete by selection  ---------------\\

    public function delete_by_selection(Request $request)
    {

        $this->authorizeForUser($request->user('api'), 'delete', Purchase::class);

        \DB::transaction(function () use ($request) {
            $role = Auth::user()->roles()->first();
            $view_records = Role::findOrFail($role->id)->inRole('record_view');
            $selectedIds = $request->selectedIds;

            foreach ($selectedIds as $purchase_id) {
                $Purchase = Purchase::findOrFail($purchase_id);
                // Check If User Has Permission view All Records
                if (!$view_records) {
                    // Check If User->id === Purchase->id
                    $this->authorizeForUser($request->user('api'), 'check_record', $Purchase);
                }
                $Purchase->details()->delete();
                $Purchase->update([
                    'deleted_at' => Carbon::now(),
                ]);

                PaymentPurchase::where('purchase_id', $purchase_id)->update([
                    'deleted_at' => Carbon::now(),
                ]);
            }

        }, 10);
        return response()->json(['success' => true, 'message' => 'Purchase Deleted !!']);

    }

    //------------------------- Send Email

    public function Send_Email(Request $request)
    {

        $this->authorizeForUser($request->user('api'), 'view', Purchase::class);

        $purchase = $request->all();
        $pdf = $this->Purchase_pdf($request, $purchase['id']);

        $this->Set_config_mail(); // Set_config_mail => BaseController
        $send_mail = Mail::to($request->to)->send(new PurchaseMail($purchase, $pdf));
        return $send_mail;
    }

    //------ Export Purchase EXCEL -------------\\

    public function exportExcel(Request $request)
    {

        $this->authorizeForUser($request->user('api'), 'view', Purchase::class);

        return Excel::download(new PurchasesExport, 'Purchases.xlsx');
    }

    //---------------- Get Details Purchase -----------------\\

    public function show(Request $request, $id)
    {

        $this->authorizeForUser($request->user('api'), 'view', Purchase::class);
        $role = Auth::user()->roles()->first();
        $view_records = Role::findOrFail($role->id)->inRole('record_view');
        $purchase = Purchase::with('details.product.unitPurchase')
            ->where('deleted_at', '=', null)
            ->findOrFail($id);

        $details = array();

        // Check If User Has Permission view All Records
        if (!$view_records) {
            // Check If User->id === purchase->id
            $this->authorizeForUser($request->user('api'), 'check_record', $purchase);
        }

        $purchase_data['Ref'] = $purchase->Ref;
        $purchase_data['date'] = $purchase->date;
        $purchase_data['statut'] = $purchase->statut;
        $purchase_data['discount'] = $purchase->discount;
        $purchase_data['shipping'] = $purchase->shipping;
        $purchase_data['tax_rate'] = $purchase->tax_rate;
        $purchase_data['TaxNet'] = $purchase->TaxNet;
        $purchase_data['supplier_name'] = $purchase['provider']->name;
        $purchase_data['supplier_email'] = $purchase['provider']->email;
        $purchase_data['supplier_phone'] = $purchase['provider']->phone;
        $purchase_data['supplier_adr'] = $purchase['provider']->adresse;
        $purchase_data['warehouse'] = $purchase['warehouse']->name;
        $purchase_data['GrandTotal'] = $purchase->GrandTotal;
        $purchase_data['paid_amount'] = $purchase->paid_amount;
        $purchase_data['due'] = $purchase->GrandTotal - $purchase->paid_amount;
        $purchase_data['payment_status'] = $purchase->payment_statut;

        foreach ($purchase['details'] as $detail) {
            if ($detail->product_variant_id) {

                $productsVariants = ProductVariant::where('product_id', $detail->product_id)
                    ->where('id', $detail->product_variant_id)->first();

                $data['quantity'] = $detail->quantity;
                $data['total'] = $detail->total;
                $data['code'] = $productsVariants->name . '-' . $detail['product']['code'];
                $data['name'] = $detail['product']['name'];
                $data['cost'] = $detail->cost;
                $data['unit_purchase'] = $detail['product']['unitPurchase']->ShortName;

            } else {

                $data['quantity'] = $detail->quantity;
                $data['total'] = $detail->total;
                $data['code'] = $detail['product']['code'];
                $data['name'] = $detail['product']['name'];
                $data['cost'] = $detail->cost;
                $data['unit_purchase'] = $detail['product']['unitPurchase']->ShortName;
            }

            if ($detail->discount_method == '2') {
                $data['DiscountNet'] = $detail->discount;
            } else {
                $data['DiscountNet'] = $detail->cost * $detail->discount / 100;
            }

            $tax_cost = $detail->TaxNet * (($detail->cost - $data['DiscountNet']) / 100);
            $data['Unit_cost'] = $detail->cost;
            $data['discount'] = $detail->discount;

            if ($detail->tax_method == '1') {

                $data['Net_cost'] = $detail->cost - $data['DiscountNet'];
                $data['taxe'] = $tax_cost;
            } else {
                $data['Net_cost'] = ($detail->cost - $data['DiscountNet']) / (($detail->TaxNet / 100) + 1);
                $data['taxe'] = $detail->cost - $data['Net_cost'] - $data['DiscountNet'];
            }

            $details[] = $data;
        }

        $company = Setting::where('deleted_at', '=', null)->first();

        return response()->json([
            'details' => $details,
            'purchase' => $purchase_data,
            'company' => $company,
        ]);

    }

    //--------------- Get Payments of Purchase ----------------\\

    public function Get_Payments(Request $request, $id)
    {

        $this->authorizeForUser($request->user('api'), 'view', PaymentPurchase::class);
        $role = Auth::user()->roles()->first();
        $view_records = Role::findOrFail($role->id)->inRole('record_view');
        $purchase = Purchase::findOrFail($id);

        // Check If User Has Permission view All Records
        if (!$view_records) {
            // Check If User->id === purchase->id
            $this->authorizeForUser($request->user('api'), 'check_record', $purchase);
        }

        $payments = PaymentPurchase::with('purchase')
            ->where('purchase_id', $id)
            ->where(function ($query) use ($view_records) {
                if (!$view_records) {
                    return $query->where('user_id', '=', Auth::user()->id);
                }
            })->orderBy('id', 'DESC')->get();

        return response()->json($payments);
    }

    //--------------- Reference Number of Purchase ----------------\\

    public function getNumberOrder()
    {

        $last = DB::table('purchases')->latest('id')->first();

        if ($last) {
            $item = $last->Ref;
            $nwMsg = explode("_", $item);
            $inMsg = $nwMsg[1] + 1;
            $code = $nwMsg[0] . '_' . $inMsg;
        } else {
            $code = 'PR_1111';
        }
        return $code;

    }

    //-------------- purchase PDF -----------\\

    public function Purchase_pdf(Request $request, $id)
    {
        $details = array();
        $helpers = new helpers();
        $Purchase_data = Purchase::with('details.product.unitPurchase')
            ->where('deleted_at', '=', null)
            ->findOrFail($id);

        $purchase['supplier_name'] = $Purchase_data['provider']->name;
        $purchase['supplier_phone'] = $Purchase_data['provider']->phone;
        $purchase['supplier_adr'] = $Purchase_data['provider']->adresse;
        $purchase['supplier_email'] = $Purchase_data['provider']->email;
        $purchase['TaxNet'] = number_format($Purchase_data->TaxNet, 2, '.', '');
        $purchase['discount'] = number_format($Purchase_data->discount, 2, '.', '');
        $purchase['shipping'] = number_format($Purchase_data->shipping, 2, '.', '');
        $purchase['statut'] = $Purchase_data->statut;
        $purchase['Ref'] = $Purchase_data->Ref;
        $purchase['date'] = $Purchase_data->date;
        $purchase['GrandTotal'] = number_format($Purchase_data->GrandTotal, 2, '.', '');
        $purchase['payment_status'] = $Purchase_data->payment_statut;

        $detail_id = 0;
        foreach ($Purchase_data['details'] as $detail) {

            if ($detail->product_variant_id) {

                $productsVariants = ProductVariant::where('product_id', $detail->product_id)
                    ->where('id', $detail->product_variant_id)->first();

                $data['code'] = $productsVariants->name . '-' . $detail['product']['code'];
            } else {
                $data['code'] = $detail['product']['code'];
            }

                $data['detail_id'] = $detail_id += 1;
                $data['quantity'] = number_format($detail->quantity, 2, '.', '');
                $data['total'] = number_format($detail->total, 2, '.', '');
                $data['name'] = $detail['product']['name'];
                $data['unit_purchase'] = $detail['product']['unitPurchase']->ShortName;
                $data['cost'] = number_format($detail->cost, 2, '.', '');

            if ($detail->discount_method == '2') {
                $data['DiscountNet'] = number_format($detail->discount, 2, '.', '');
            } else {
                $data['DiscountNet'] = number_format($detail->cost * $detail->discount / 100, 2, '.', '');
            }

            $tax_cost = $detail->TaxNet * (($detail->cost - $data['DiscountNet']) / 100);
            $data['Unit_cost'] = number_format($detail->cost, 2, '.', '');
            $data['discount'] = number_format($detail->discount, 2, '.', '');

            if ($detail->tax_method == '1') {

                $data['Net_cost'] = $detail->cost - $data['DiscountNet'];
                $data['taxe'] = number_format($tax_cost, 2, '.', '');
            } else {
                $data['Net_cost'] = ($detail->cost - $data['DiscountNet']) / (($detail->TaxNet / 100) + 1);
                $data['taxe'] = number_format($detail->cost - $data['Net_cost'] - $data['DiscountNet'], 2, '.', '');
            }

            $details[] = $data;
        }

        $settings = Setting::where('deleted_at', '=', null)->first();
        $symbol = $helpers->Get_Currency();

        $pdf = \PDF::loadView('pdf.purchase_pdf', [
            'symbol' => $symbol,
            'setting' => $settings,
            'purchase' => $purchase,
            'details' => $details,
        ]);
        return $pdf->download('Purchase.pdf');

    }

    //---------------- Show Form Create Purchase ---------------\\

    public function create(Request $request)
    {

        $this->authorizeForUser($request->user('api'), 'create', Purchase::class);

        $warehouses = Warehouse::where('deleted_at', '=', null)->get(['id', 'name']);
        $suppliers = Provider::where('deleted_at', '=', null)->get(['id', 'name']);

        return response()->json([
            'warehouses' => $warehouses,
            'suppliers' => $suppliers,
        ]);
    }

    //-------------Show Form Edit Purchase-----------\\

    public function edit(Request $request, $id)
    {

        $this->authorizeForUser($request->user('api'), 'update', Purchase::class);
        $role = Auth::user()->roles()->first();
        $view_records = Role::findOrFail($role->id)->inRole('record_view');
        $Purchase_data = Purchase::with('details.product.unitPurchase')
            ->where('deleted_at', '=', null)
            ->findOrFail($id);
        $details = array();
        // Check If User Has Permission view All Records
        if (!$view_records) {
            // Check If User->id === Purchase->id
            $this->authorizeForUser($request->user('api'), 'check_record', $Purchase_data);
        }

        if ($Purchase_data->provider_id) {
            if (Provider::where('id', $Purchase_data->provider_id)->where('deleted_at', '=', null)->first()) {
                $purchase['supplier_id'] = $Purchase_data->provider_id;
            } else {
                $purchase['supplier_id'] = '';
            }
        } else {
            $purchase['supplier_id'] = '';
        }

        if ($Purchase_data->warehouse_id) {
            if (Warehouse::where('id', $Purchase_data->warehouse_id)->where('deleted_at', '=', null)->first()) {
                $purchase['warehouse_id'] = $Purchase_data->warehouse_id;
            } else {
                $purchase['warehouse_id'] = '';
            }
        } else {
            $purchase['warehouse_id'] = '';
        }

        $purchase['date'] = $Purchase_data->date;
        $purchase['tax_rate'] = $Purchase_data->tax_rate;
        $purchase['TaxNet'] = $Purchase_data->TaxNet;
        $purchase['discount'] = $Purchase_data->discount;
        $purchase['shipping'] = $Purchase_data->shipping;
        $purchase['statut'] = $Purchase_data->statut;
        $purchase['notes'] = $Purchase_data->notes;

        $detail_id = 0;
        foreach ($Purchase_data['details'] as $detail) {
            $unit = Product::with('unitPurchase')->where('id', $detail->product_id)
                ->where('deleted_at', '=', null)->first();

            if ($detail->product_variant_id) {
                $item_product = product_warehouse::where('product_id', $detail->product_id)
                    ->where('deleted_at', '=', null)
                    ->where('product_variant_id', $detail->product_variant_id)
                    ->where('warehouse_id', $Purchase_data->warehouse_id)
                    ->first();

                $productsVariants = ProductVariant::where('product_id', $detail->product_id)
                    ->where('id', $detail->product_variant_id)->first();

                $data['id'] = $detail->id;
                $data['detail_id'] = $detail_id += 1;
                $data['quantity'] = $detail->quantity;
                $data['product_id'] = $detail->product_id;
                $data['product_variant_id'] = $detail->product_variant_id;
                $data['code'] = $productsVariants->name . '-' . $detail['product']['code'];
                $data['name'] = $detail['product']['name'];
                $item_product ? $data['del'] = 0 : $data['del'] = 1;

                if ($unit && $unit['unitPurchase']->operator == '/') {
                    $data['stock'] = $item_product ? $item_product->qte * $unit['unitPurchase']->operator_value : 0;
                } else if ($unit && $unit['unitPurchase']->operator == '*') {
                    $data['stock'] = $item_product ? $item_product->qte / $unit['unitPurchase']->operator_value : 0;
                } else {
                    $data['stock'] = 0;
                }

                $data['unitPurchase'] = $detail['product']['unitPurchase']->ShortName;

            } else {
                $item_product = product_warehouse::where('product_id', $detail->product_id)
                    ->where('deleted_at', '=', null)->where('product_variant_id', '=', null)
                    ->where('warehouse_id', $Purchase_data->warehouse_id)->first();

                $data['id'] = $detail->id;
                $data['detail_id'] = $detail_id += 1;
                $data['quantity'] = $detail->quantity;
                $data['product_id'] = $detail->product_id;
                $data['product_variant_id'] = null;
                $data['total'] = $detail->total;
                $data['code'] = $detail['product']['code'];
                $data['name'] = $detail['product']['name'];
                $item_product ? $data['del'] = 0 : $data['del'] = 1;

                if ($unit && $unit['unitPurchase']->operator == '/') {
                    $data['stock'] = $item_product ? $item_product->qte * $unit['unitPurchase']->operator_value : 0;
                } else if ($unit && $unit['unitPurchase']->operator == '*') {
                    $data['stock'] = $item_product ? $item_product->qte / $unit['unitPurchase']->operator_value : 0;
                } else {
                    $data['stock'] = 0;
                }

                $data['unitPurchase'] = $detail['product']['unitPurchase']->ShortName;

            }

            if ($detail->discount_method == '2') {
                $data['DiscountNet'] = $detail->discount;
            } else {
                $data['DiscountNet'] = $detail->cost * $detail->discount / 100;
            }

            $tax_cost = $detail->TaxNet * (($detail->cost - $data['DiscountNet']) / 100);
            $data['Unit_cost'] = $detail->cost;
            $data['tax_percent'] = $detail->TaxNet;
            $data['tax_method'] = $detail->tax_method;
            $data['discount'] = $detail->discount;
            $data['discount_Method'] = $detail->discount_method;

            if ($detail->tax_method == '1') {
                $data['Net_cost'] = $detail->cost - $data['DiscountNet'];
                $data['taxe'] = $tax_cost;
                $data['subtotal'] = ($data['Net_cost'] * $data['quantity']) + ($tax_cost * $data['quantity']);
            } else {
                $data['Net_cost'] = ($detail->cost - $data['DiscountNet']) / (($detail->TaxNet / 100) + 1);
                $data['taxe'] = $detail->cost - $data['Net_cost'] - $data['DiscountNet'];
                $data['subtotal'] = ($data['Net_cost'] * $data['quantity']) + ($tax_cost * $data['quantity']);
            }

            $details[] = $data;
        }

        $warehouses = Warehouse::where('deleted_at', '=', null)->get(['id', 'name']);
        $suppliers = Provider::where('deleted_at', '=', null)->get(['id', 'name']);

        return response()->json([
            'details' => $details,
            'purchase' => $purchase,
            'suppliers' => $suppliers,
            'warehouses' => $warehouses,
        ]);
    }

    //------------------ Send SMS ----------------------------------\\

    public function Send_SMS(Request $request)
    {
        $Purchase = Purchase::where('deleted_at', '=', null)->findOrFail($request->id);
        $url = url('/Purchase_PDF/' . $request->id);
        $receiverNumber = $Purchase['provider']->phone;
        $message = "Dear" .' '.$Purchase['provider']->name." \n We are contacting you in regard to a purchase order #".$Purchase->Ref.' '.$url.' '. "that has been created on your account. \n We look forward to conducting future business with you.";
        try {
  
            $account_sid = env("TWILIO_SID");
            $auth_token = env("TWILIO_TOKEN");
            $twilio_number = env("TWILIO_FROM");
  
            $client = new Client_Twilio($account_sid, $auth_token);
            $client->messages->create($receiverNumber, [
                'from' => $twilio_number, 
                'body' => $message]);
    
        } catch (Exception $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }

}
