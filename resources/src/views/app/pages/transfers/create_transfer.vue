<template>
  <div class="main-content">
    <breadcumb :page="$t('Create_Transfer')" :folder="$t('ListTransfers')"/>
    <div v-if="isLoading" class="loading_page spinner spinner-primary mr-3"></div>

    <validation-observer ref="Create_transfer" v-if="!isLoading">
      <b-form @submit.prevent="Submit_Transfer">
        <b-row>
          <b-col lg="12" md="12" sm="12">
            <b-card>
              <b-row>

                 <!-- date  -->
                <b-col lg="4" md="4" sm="12" class="mb-3">
                  <validation-provider
                    name="date"
                    :rules="{ required: true}"
                    v-slot="validationContext"
                  >
                    <b-form-group :label="$t('date')">
                      <b-form-input
                        :state="getValidationState(validationContext)"
                        aria-describedby="date-feedback"
                        type="date"
                        v-model="transfer.date"
                      ></b-form-input>
                      <b-form-invalid-feedback
                        id="OrderTax-feedback"
                      >{{ validationContext.errors[0] }}</b-form-invalid-feedback>
                    </b-form-group>
                  </validation-provider>
                </b-col>
                <!-- From warehouse -->
                <b-col lg="4" md="4" sm="12" class="mb-3">
                  <validation-provider name="From Warehouse" :rules="{ required: true}">
                    <b-form-group slot-scope="{ valid, errors }" :label="$t('FromWarehouse')">
                      <v-select
                        :class="{'is-invalid': !!errors.length}"
                        :state="errors[0] ? false : (valid ? true : null)"
                        :disabled="details.length > 0"
                        @input="Selected_From_Warehouse"
                        v-model="transfer.from_warehouse"
                        :reduce="label => label.value"
                        :placeholder="$t('Choose_Warehouse')"
                        :options="warehouses.map(warehouses => ({label: warehouses.name, value: warehouses.id}))"
                      />
                      <b-form-invalid-feedback>{{ errors[0] }}</b-form-invalid-feedback>
                    </b-form-group>
                  </validation-provider>
                </b-col>

                <!-- To warehouse -->
                <b-col lg="4" md="4" sm="12" class="mb-3">
                  <validation-provider name="To Warehouse" :rules="{ required: true}">
                    <b-form-group slot-scope="{ valid, errors }" :label="$t('ToWarehouse')">
                      <v-select
                        :class="{'is-invalid': !!errors.length}"
                        :state="errors[0] ? false : (valid ? true : null)"
                        v-model="transfer.to_warehouse"
                        :reduce="label => label.value"
                        :placeholder="$t('Choose_Warehouse')"
                        :options="warehouses.map(warehouses => ({label: warehouses.name, value: warehouses.id}))"
                      />
                      <b-form-invalid-feedback>{{ errors[0] }}</b-form-invalid-feedback>
                    </b-form-group>
                  </validation-provider>
                </b-col>

                <!-- Product -->
                <b-col md="12" class="mb-5">
                  <h6>{{$t('ProductName')}}</h6>
                  <autocomplete
                    :search="search"
                    :placeholder="$t('Search_Product_by_Code_Name')"
                    aria-label="Search for a Product"
                    :get-result-value="getResultValue"
                    @submit="SearchProduct"
                    ref="autocomplete"
                  />
                </b-col>

                <!-- order products  -->
                <b-col md="12">
                  <div class="table-responsive">
                    <table class="table table-hover">
                      <thead class="bg-gray-300">
                        <tr>
                          <th scope="col">#</th>
                          <th scope="col">{{$t('ProductName')}}</th>
                          <th scope="col">{{$t('Net_Unit_Cost')}}</th>
                          <th scope="col">{{$t('CurrentStock')}}</th>
                          <th scope="col">{{$t('Qty')}}</th>
                          <th scope="col">{{$t('Discount')}}</th>
                          <th scope="col">{{$t('Tax')}}</th>
                          <th scope="col">{{$t('SubTotal')}}</th>
                          <th scope="col" class="text-center">
                            <i class="fa fa-trash"></i>
                          </th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr v-if="details.length <=0">
                          <td colspan="9">{{$t('NodataAvailable')}}</td>
                        </tr>
                        <tr v-for="detail in details">
                          <td>{{detail.detail_id}}</td>
                          <td>
                            <span>{{detail.code}}</span>
                            <br>
                            <span class="badge badge-success">{{detail.name}}</span>
                            <i @click="Modal_Updat_Detail(detail)" class="i-Edit"></i>
                          </td>
                          <td>{{formatNumber(detail.Net_cost, 2)}} {{currentUser.currency}}</td>
                          <td>
                            <span
                              class="badge badge-outline-warning"
                            >{{detail.stock}} {{detail.unitPurchase}}</span>
                          </td>
                          <td>
                            <div class="quantity">
                              <b-input-group>
                                <b-input-group-prepend>
                                  <span
                                    class="btn btn-primary btn-sm"
                                    @click="decrement(detail ,detail.detail_id)"
                                  >-</span>
                                </b-input-group-prepend>
                                <input
                                  class="form-control"
                                  @keyup="Verified_Qty(detail,detail.detail_id)"
                                  v-model.number="detail.quantity"
                                >
                                <b-input-group-append>
                                  <span
                                    class="btn btn-primary btn-sm"
                                    @click="increment(detail ,detail.detail_id)"
                                  >+</span>
                                </b-input-group-append>
                              </b-input-group>
                            </div>
                          </td>
                          <td>{{formatNumber(detail.DiscountNet, 2)}} {{currentUser.currency}}</td>
                          <td>{{formatNumber(detail.taxe , 2)}} {{currentUser.currency}}</td>
                          <td>{{formatNumber(detail.subtotal, 2)}} {{currentUser.currency}}</td>
                          <td>
                            <a
                              @click="delete_Product_Detail(detail.detail_id)"
                              class="btn btn-icon btn-sm"
                              title="Delete"
                            >
                              <i class="i-Close-Window text-25 text-danger"></i>
                            </a>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </b-col>

                <div class="offset-md-9 col-md-3 mt-4">
                  <table class="table table-striped table-sm">
                    <tbody>
                      <tr>
                        <td class="bold">{{$t('OrderTax')}}</td>
                        <td>
                          <span>{{formatNumber(transfer.TaxNet ,2)}} {{currentUser.currency}} ({{formatNumber(transfer.tax_rate ,2)}} %)</span>
                        </td>
                      </tr>
                      <tr>
                        <td class="bold">{{$t('Discount')}}</td>
                        <td>{{formatNumber(transfer.discount ,2)}} {{currentUser.currency}}</td>
                      </tr>
                      <tr>
                        <td class="bold">{{$t('Shipping')}}</td>
                        <td>{{formatNumber(transfer.shipping ,2)}} {{currentUser.currency}}</td>
                      </tr>
                      <tr>
                        <td>
                          <span class="font-weight-bold">{{$t('Total')}}</span>
                        </td>
                        <td>
                          <span
                            class="font-weight-bold"
                          >{{formatNumber(GrandTotal ,2)}} {{currentUser.currency}}</span>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>

                <!-- Order Tax  -->
                <b-col lg="4" md="4" sm="12" class="mb-3">
                  <validation-provider
                    name="Order Tax"
                    :rules="{ regex: /^\d*\.?\d*$/}"
                    v-slot="validationContext"
                  >
                    <b-form-group :label="$t('OrderTax')">
                      <b-input-group append="%">
                        <b-form-input
                          :state="getValidationState(validationContext)"
                          aria-describedby="OrderTax-feedback"
                          label="Order Tax"
                          v-model.number="transfer.tax_rate"
                          @keyup="keyup_OrderTax()"
                        ></b-form-input>
                      </b-input-group>
                      <b-form-invalid-feedback
                        id="OrderTax-feedback"
                      >{{ validationContext.errors[0] }}</b-form-invalid-feedback>
                    </b-form-group>
                  </validation-provider>
                </b-col>

                <!-- Discount -->
                <b-col lg="4" md="4" sm="12" class="mb-3">
                  <validation-provider
                    name="Discount"
                    :rules="{ regex: /^\d*\.?\d*$/}"
                    v-slot="validationContext"
                  >
                    <b-form-group :label="$t('Discount')">
                      <b-input-group append="$">
                        <b-form-input
                          :state="getValidationState(validationContext)"
                          aria-describedby="Discount-feedback"
                          label="Discount"
                          v-model.number="transfer.discount"
                          @keyup="keyup_Discount()"
                        ></b-form-input>
                      </b-input-group>
                      <b-form-invalid-feedback
                        id="Discount-feedback"
                      >{{ validationContext.errors[0] }}</b-form-invalid-feedback>
                    </b-form-group>
                  </validation-provider>
                </b-col>

                <!-- Shipping  -->
                <b-col lg="4" md="4" sm="12" class="mb-3">
                  <validation-provider
                    name="Shipping"
                    :rules="{ regex: /^\d*\.?\d*$/}"
                    v-slot="validationContext"
                  >
                    <b-form-group :label="$t('Shipping')">
                      <b-input-group append="$">
                        <b-form-input
                          :state="getValidationState(validationContext)"
                          aria-describedby="Shipping-feedback"
                          label="Shipping"
                          v-model.number="transfer.shipping"
                          @keyup="keyup_Shipping()"
                        ></b-form-input>
                      </b-input-group>
                      <b-form-invalid-feedback
                        id="Shipping-feedback"
                      >{{ validationContext.errors[0] }}</b-form-invalid-feedback>
                    </b-form-group>
                  </validation-provider>
                </b-col>

                 <!-- Status  -->
                <b-col lg="4" md="4" sm="12" class="mb-3">
                  <validation-provider name="Status" :rules="{ required: true}">
                    <b-form-group slot-scope="{ valid, errors }" :label="$t('Status')">
                      <v-select
                        :class="{'is-invalid': !!errors.length}"
                        :state="errors[0] ? false : (valid ? true : null)"
                        v-model="transfer.statut"
                        :reduce="label => label.value"
                        :placeholder="$t('Choose_Status')"
                        :options="
                                [{label: 'Completed', value: 'completed'},
                                {label: 'Sent', value: 'sent'},
                                {label: 'Pending', value: 'pending'}
                            ]"
                      ></v-select>
                      <b-form-invalid-feedback>{{ errors[0] }}</b-form-invalid-feedback>
                    </b-form-group>
                  </validation-provider>
                </b-col>

                <b-col md="12">
                  <b-form-group :label="$t('Note')">
                    <textarea
                      v-model="transfer.notes"
                      rows="4"
                      class="form-control"
                      :placeholder="$t('Afewwords')"
                    ></textarea>
                  </b-form-group>
                </b-col>
                <b-col md="12">
                  <b-form-group>
                    <b-button variant="primary" type="submit">{{$t('submit')}}</b-button>
                  </b-form-group>
                </b-col>
              </b-row>
            </b-card>
          </b-col>
        </b-row>
      </b-form>
    </validation-observer>

    <!-- Modal Update detail Product -->
    <validation-observer ref="Update_Detail_transfer">
      <b-modal hide-footer size="md" id="form_Update_Detail" :title="detail.name">
        <b-form @submit.prevent="submit_Update_Detail">
          <b-row>
            <!-- Unit Cost -->
            <b-col lg="12" md="12" sm="12">
              <validation-provider
                name="Product Cost"
                :rules="{ required: true , regex: /^\d*\.?\d*$/}"
                v-slot="validationContext"
              >
                <b-form-group :label="$t('ProductCost')" id="cost-input">
                  <b-form-input
                    label="Product Cost"
                    v-model.number="detail.Unit_cost"
                    :state="getValidationState(validationContext)"
                    aria-describedby="cost-feedback"
                  ></b-form-input>
                  <b-form-invalid-feedback id="cost-feedback">{{ validationContext.errors[0] }}</b-form-invalid-feedback>
                </b-form-group>
              </validation-provider>
            </b-col>

            <!-- Tax Method -->
            <b-col lg="12" md="12" sm="12">
              <validation-provider name="Tax Method" :rules="{ required: true}">
                <b-form-group slot-scope="{ valid, errors }" :label="$t('TaxMethod')">
                  <v-select
                    :class="{'is-invalid': !!errors.length}"
                    :state="errors[0] ? false : (valid ? true : null)"
                    v-model="detail.tax_method"
                    :reduce="label => label.value"
                    :placeholder="$t('Choose_Method')"
                    :options="
                           [
                            {label: 'Exclusive', value: '1'},
                            {label: 'Inclusive', value: '2'}
                           ]"
                  ></v-select>
                  <b-form-invalid-feedback>{{ errors[0] }}</b-form-invalid-feedback>
                </b-form-group>
              </validation-provider>
            </b-col>

            <!-- Tax Rate -->
            <b-col lg="12" md="12" sm="12">
              <validation-provider
                name="Order Tax"
                :rules="{ required: true , regex: /^\d*\.?\d*$/}"
                v-slot="validationContext"
              >
                <b-form-group :label="$t('OrderTax')">
                  <b-input-group append="%">
                    <b-form-input
                      label="Order Tax"
                      v-model.number="detail.tax_percent"
                      :state="getValidationState(validationContext)"
                      aria-describedby="OrderTax-feedback"
                    ></b-form-input>
                  </b-input-group>
                  <b-form-invalid-feedback id="OrderTax-feedback">{{ validationContext.errors[0] }}</b-form-invalid-feedback>
                </b-form-group>
              </validation-provider>
            </b-col>

            <!-- Discount Method -->
            <b-col lg="12" md="12" sm="12">
              <validation-provider name="Discount Method" :rules="{ required: true}">
                <b-form-group slot-scope="{ valid, errors }" :label="$t('Discount_Method')">
                  <v-select
                    v-model="detail.discount_Method"
                    :reduce="label => label.value"
                    :placeholder="$t('Choose_Method')"
                    :class="{'is-invalid': !!errors.length}"
                    :state="errors[0] ? false : (valid ? true : null)"
                    :options="
                           [
                            {label: 'Percent %', value: '1'},
                            {label: 'Fixed', value: '2'}
                           ]"
                  ></v-select>
                  <b-form-invalid-feedback>{{ errors[0] }}</b-form-invalid-feedback>
                </b-form-group>
              </validation-provider>
            </b-col>

            <!-- Discount Rate -->
            <b-col lg="12" md="12" sm="12">
              <validation-provider
                name="Discount Rate"
                :rules="{ required: true , regex: /^\d*\.?\d*$/}"
                v-slot="validationContext"
              >
                <b-form-group :label="$t('Discount')">
                  <b-form-input
                    label="Discount"
                    v-model.number="detail.discount"
                    :state="getValidationState(validationContext)"
                    aria-describedby="Discount-feedback"
                  ></b-form-input>
                  <b-form-invalid-feedback id="Discount-feedback">{{ validationContext.errors[0] }}</b-form-invalid-feedback>
                </b-form-group>
              </validation-provider>
            </b-col>

            <b-col md="12">
              <b-form-group>
                <b-button variant="primary" type="submit">{{$t('submit')}}</b-button>
              </b-form-group>
            </b-col>
          </b-row>
        </b-form>
      </b-modal>
    </validation-observer>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import NProgress from "nprogress";

export default {
  metaInfo: {
    title: "Create Transfer"
  },
  data() {
    return {
      isLoading: true,
      details: [],
      detail: {
        quantity: "",
        discount: "",
        Unit_cost: "",
        discount_Method: "",
        tax_percent: "",
        tax_method: ""
      },
      warehouses: [],
      products: [],
      symbol: "",
      transfer: {
        id: "",
        from_warehouse: "",
        to_warehouse: "",
        statut: "completed",
        notes: "",
        date: new Date().toISOString().slice(0, 10),
        items: 0,
        tax_rate: 0,
        TaxNet: 0,
        shipping: 0,
        discount: 0
      },
      total: 0,
      GrandTotal: 0,
      product: {
        id: "",
        code: "",
        stock: "",
        quantity: 1,
        discount: "",
        DiscountNet: "",
        discount_Method: "",
        name: "",
        unitPurchase: "",
        Net_cost: "",
        Unit_cost: "",
        Total_cost: "",
        subtotal: "",
        product_id: "",
        detail_id: "",
        taxe: "",
        tax_percent: "",
        tax_method: "",
        product_variant_id: ""
      }
    };
  },
  computed: {
    ...mapGetters(["currentUser"])
  },

  methods: {
    //------------- Submit Validation Create Transfer
    Submit_Transfer() {
      this.$refs.Create_transfer.validate().then(success => {
        if (!success) {
          this.makeToast(
            "danger",
            this.$t("Please_fill_the_form_correctly"),
            this.$t("Failed")
          );
        } else {
          this.Create_Transfer();
        }
      });
    },

    //---Submit Validation Update Detail
    submit_Update_Detail() {
      this.$refs.Update_Detail_transfer.validate().then(success => {
        if (!success) {
          return;
        } else {
          this.Update_Detail();
        }
      });
    },

    //---Show Modal Update Detail Product
    Modal_Updat_Detail(detail) {
      this.detail = {};
      this.detail.name = detail.name;
      this.detail.detail_id = detail.detail_id;
      this.detail.Unit_cost = detail.Unit_cost;
      this.detail.tax_method = detail.tax_method;
      this.detail.discount_Method = detail.discount_Method;
      this.detail.discount = detail.discount;
      this.detail.quantity = detail.quantity;
      this.detail.tax_percent = detail.tax_percent;
      this.$bvModal.show("form_Update_Detail");
    },

    //--- Submit Update Detail Product

    Update_Detail() {
      for (var i = 0; i < this.details.length; i++) {
        if (this.details[i].detail_id === this.detail.detail_id) {
          this.details[i].tax_percent = this.detail.tax_percent;
          this.details[i].Unit_cost = this.detail.Unit_cost;
          this.details[i].quantity = this.detail.quantity;
          this.details[i].tax_method = this.detail.tax_method;
          this.details[i].discount_Method = this.detail.discount_Method;
          this.details[i].discount = this.detail.discount;

          if (this.details[i].discount_Method == "2") {
            //Fixed
            this.details[i].DiscountNet = this.detail.discount;
          } else {
            //Percentage %
            this.details[i].DiscountNet = parseFloat(
              (this.detail.Unit_cost * this.details[i].discount) / 100
            );
          }

          if (this.details[i].tax_method == "1") {
            //Exclusive
            this.details[i].Net_cost = parseFloat(
              this.detail.Unit_cost - this.details[i].DiscountNet
            );
            this.details[i].taxe = parseFloat(
              (this.detail.tax_percent *
                (this.detail.Unit_cost - this.details[i].DiscountNet)) /
                100
            );
          } else {
            //Inclusive
            this.details[i].Net_cost = parseFloat(
              (this.detail.Unit_cost - this.details[i].DiscountNet) /
                (this.detail.tax_percent / 100 + 1)
            );
            this.details[i].taxe = parseFloat(
              this.detail.Unit_cost -
                this.details[i].Net_cost -
                this.details[i].DiscountNet
            );
          }

          this.$forceUpdate();
        }
      }
      this.Calcul_Total();
      this.$bvModal.hide("form_Update_Detail");
    },

    //------ Toast
    makeToast(variant, msg, title) {
      this.$root.$bvToast.toast(msg, {
        title: title,
        variant: variant,
        solid: true
      });
    },

    //---Validate State Fields
    getValidationState({ dirty, validated, valid = null }) {
      return dirty || validated ? valid : null;
    },

    //-------------------- Search Product
    search(input) {
      if (input.length < 1) {
        return [];
      }
      if (this.transfer.from_warehouse != "") {
        return this.products.filter(product => {
          return (
            product.name.toLowerCase().startsWith(input.toLowerCase()) ||
            product.code.toLowerCase().startsWith(input.toLowerCase())
          );
        });
      } else {
        this.makeToast(
          "warning",
          this.$t("SelectWarehouse"),
          this.$t("Warning")
        );
      }
    },

    //-------------------- get Result Value Search Product

    getResultValue(result) {
      return result.code + " " + "(" + result.name + ")";
    },

    //--------------------  Submit Search Product

    SearchProduct(result) {
      this.product = {};
      if (
        this.details.length > 0 &&
        this.details.some(detail => detail.code === result.code)
      ) {
        this.makeToast("warning", this.$t("AlreadyAdd"), this.$t("Warning"));
      } else {
        this.product.code = result.code;
        this.product.stock = result.qte_purchase;
        if (result.qte_purchase < 1) {
          this.product.quantity = result.qte_purchase;
        } else {
          this.product.quantity = 1;
        }
        this.product.product_variant_id = result.product_variant_id;
        this.Get_Product_Details(result.id);
      }
      this.$refs.autocomplete.value = "";
    },

    //-----------------------------------------Calcul Total ------------------------------\\
    Calcul_Total() {
      this.total = 0;
      for (let index = 0; index < this.details.length; index++) {
        var tax = this.details[index].taxe * this.details[index].quantity;
        this.details[index].subtotal = parseFloat(
          this.details[index].quantity * this.details[index].Net_cost + tax
        );
        this.total = parseFloat(this.total + this.details[index].subtotal);
      }

      const total_without_discount = parseFloat(
        this.total - this.transfer.discount
      );
      this.transfer.TaxNet = parseFloat(
        (total_without_discount * this.transfer.tax_rate) / 100
      );
      this.GrandTotal = parseFloat(
        total_without_discount + this.transfer.TaxNet + this.transfer.shipping
      );
    },

    //---------- keyup OrderTax
    keyup_OrderTax() {
      if (isNaN(this.transfer.tax_rate)) {
        this.transfer.tax_rate = 0;
      } else {
        this.Calcul_Total();
      }
    },

    //---------- keyup Discount

    keyup_Discount() {
      if (isNaN(this.transfer.discount)) {
        this.transfer.discount = 0;
      } else {
        this.Calcul_Total();
      }
    },

    //---------- keyup Shipping

    keyup_Shipping() {
      if (isNaN(this.transfer.shipping)) {
        this.transfer.shipping = 0;
      } else {
        this.Calcul_Total();
      }
    },

    //-----------------------------------Delete Detail Product ------------------------------\\
    delete_Product_Detail(id) {
      for (var i = 0; i < this.details.length; i++) {
        if (id === this.details[i].detail_id) {
          this.details.splice(i, 1);
          this.Calcul_Total();
        }
      }
    },

    //-----------------------------------Verified Form ------------------------------\\

    verifiedForm() {
      if (this.details.length <= 0) {
        this.makeToast(
          "warning",
          this.$t("AddProductToList"),
          this.$t("Warning")
        );
        return false;
      } else if (this.transfer.from_warehouse === this.transfer.to_warehouse) {
        this.makeToast(
          "warning",
          this.$t("WarehouseIdentical"),
          this.$t("Warning")
        );
        return false;
      } else {
        var count = 0;
        for (var i = 0; i < this.details.length; i++) {
          if (
            this.details[i].quantity == "" ||
            this.details[i].quantity === 0
          ) {
            count += 1;
          }
        }

        if (count > 0) {
          this.makeToast("warning", this.$t("AddQuantity"), this.$t("Warning"));
          return false;
        } else {
          return true;
        }
      }
    },

    //-------------------------------- Create Transfer ----------------------\\
    Create_Transfer() {
      if (this.verifiedForm()) {
        // Start the progress bar.
        NProgress.start();
        NProgress.set(0.1);
        axios
          .post("transfers", {
            transfer: this.transfer,
            details: this.details,
            GrandTotal: this.GrandTotal
          })
          .then(response => {
            // Complete the animation of theprogress bar.
            NProgress.done();
            this.$router.push({
              name: "index_transfer"
            });

            this.makeToast(
              "success",
              this.$t("Create.TitleTransfer"),
              this.$t("Success")
            );
          })
          .catch(error => {
            // Complete the animation of theprogress bar.
            NProgress.done();
            this.makeToast("danger", this.$t("InvalidData"), this.$t("Failed"));
          });
      }
    },

    //-------------------------------- Get Last Detail Id -------------------------\\
    Last_Detail_id() {
      this.product.detail_id = 0;
      var len = this.details.length;
      this.product.detail_id = this.details[len - 1].detail_id + 1;
    },

    //----------------------------------------- Add Detail of Transfer -------------------------\\
    add_Detail() {
      if (this.details.length > 0) {
        this.Last_Detail_id();
      } else if (this.details.length === 0) {
        this.product.detail_id = 1;
      }

      this.details.push(this.product);
    },

    //-----------------------------------Verified QTY ------------------------------\\
    Verified_Qty(detail, id) {
      for (var i = 0; i < this.details.length; i++) {
        if (this.details[i].detail_id === id) {
          if (isNaN(detail.quantity)) {
            this.details[i].quantity = detail.stock;
          }

          if (detail.quantity > detail.stock) {
            this.makeToast("warning", this.$t("LowStock"), this.$t("Warning"));
            this.details[i].quantity = this.formatNumber(detail.stock, 2);
          } else {
            this.details[i].quantity = this.formatNumber(detail.quantity, 2);
          }
        }
      }
      this.Calcul_Total();
      this.$forceUpdate();
    },

    //-----------------------------------increment QTY ------------------------------\\

    increment(detail, id) {
      for (var i = 0; i < this.details.length; i++) {
        if (this.details[i].detail_id == id) {
          if (detail.quantity + 1 > detail.stock) {
            this.makeToast("warning", this.$t("LowStock"), this.$t("Warning"));
          } else {
            this.formatNumber(this.details[i].quantity++, 2);
          }
        }
      }
      this.Calcul_Total();
      this.$forceUpdate();
    },

    //-----------------------------------decrement QTY ------------------------------\\

    decrement(detail, id) {
      for (var i = 0; i < this.details.length; i++) {
        if (this.details[i].detail_id === id) {
          if (detail.quantity - 1 >= 1) {
            if (detail.quantity - 1 > detail.stock) {
              this.makeToast(
                "warning",
                this.$t("LowStock"),
                this.$t("Warning")
              );
            } else {
              this.formatNumber(this.details[i].quantity--, 2);
            }
          }
        }
      }
      this.Calcul_Total();
      this.$forceUpdate();
    },

    //------------------------------Formetted Numbers -------------------------\\
    formatNumber(number, dec) {
      const value = (typeof number === "string"
        ? number
        : number.toString()
      ).split(".");
      if (dec <= 0) return value[0];
      let formated = value[1] || "";
      if (formated.length > dec)
        return `${value[0]}.${formated.substr(0, dec)}`;
      while (formated.length < dec) formated += "0";
      return `${value[0]}.${formated}`;
    },

    //------------------------------------ Get Products By warehouse -------------------------\\

    Get_Products_By_Warehouse(id) {
      axios
        .get("Products/Warehouse/" + id + "?stock=" + 1)
        .then(({ data }) => (this.products = data));
    },

    //---------------------------------Get Product Details ------------------------\\

    Get_Product_Details(product_id) {
      axios.get("Products/" + product_id).then(response => {
        this.product.discount = 0;
        this.product.DiscountNet = 0;
        this.product.discount_Method = "2";
        this.product.product_id = response.data.id;
        this.product.name = response.data.name;
        this.product.Net_cost = response.data.Net_cost;
        this.product.Unit_cost = response.data.Unit_cost;
        this.product.taxe = response.data.tax_cost;
        this.product.tax_method = response.data.tax_method;
        this.product.tax_percent = response.data.tax_percent;
        this.product.unitPurchase = response.data.unitPurchase;
        this.add_Detail();
        this.Calcul_Total();
      });
    },

    //---------------------- Event Select From Warehouse ------------------------------\\
    Selected_From_Warehouse(value) {
      this.Get_Products_By_Warehouse(value);
    },

    //-------------------------------------- Get Elements Create Transfer----------------------\\
    Get_Elements() {
      axios
        .get("transfers/create")
        .then(response => {
          this.warehouses = response.data.warehouses;
          this.isLoading = false;
        })
        .catch(response => {
          setTimeout(() => {
            this.isLoading = false;
          }, 500);
        });
    }
  },

  //----------------------------- Created function-------------------
  created: function() {
    this.Get_Elements();
  }
};
</script>
