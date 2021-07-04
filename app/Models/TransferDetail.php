<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TransferDetail extends Model
{
    protected $table = 'transfer_details';

    protected $fillable = [
        'id', 'transfer_id', 'quantity', 'product_id', 'total', 'product_variant_id',
        'cost', 'TaxNet', 'discount', 'discount_method', 'tax_method',
    ];

    protected $casts = [
        'total' => 'double',
        'cost' => 'double',
        'TaxNet' => 'double',
        'discount' => 'double',
        'quantity' => 'double',
        'transfer_id' => 'integer',
        'product_id' => 'integer',
        'product_variant_id' => 'integer',
    ];

    public function transfer()
    {
        return $this->belongsTo('App\Models\Transfer');
    }

    public function product()
    {
        return $this->belongsTo('App\Models\Product');
    }

}
