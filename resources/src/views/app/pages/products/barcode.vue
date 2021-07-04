<template>
  <div class="main-content">
    <breadcumb :page="$t('Printbarcode')" :folder="$t('Products')"/>
    <div v-if="isLoading" class="loading_page spinner spinner-primary mr-3"></div>
    <b-card v-if="!isLoading">
      <b-row>
        <!-- Warehouse -->
        <b-col md="6" class="mb-3">
          <validation-observer ref="show_Barcode">
            <validation-provider name="warehouse" :rules="{ required: true}">
              <b-form-group slot-scope="{ valid, errors }" :label="$t('warehouse')">
                <v-select
                  :class="{'is-invalid': !!errors.length}"
                  :state="errors[0] ? false : (valid ? true : null)"
                  @input="Selected_Warehouse"
                  v-model="barcode.warehouse_id"
                  :reduce="label => label.value"
                  :placeholder="$t('Choose_Warehouse')"
                  :options="warehouses.map(warehouses => ({label: warehouses.name, value: warehouses.id}))"
                />
                <b-form-invalid-feedback>{{ errors[0] }}</b-form-invalid-feedback>
              </b-form-group>
            </validation-provider>
          </validation-observer>
        </b-col>

        <!-- Product -->
        <b-col md="12" class="mb-3">
          <b-form-group :label="$t('ProductName')">
            <autocomplete
              :search="search"
              :placeholder="$t('Search_Product_by_Code_Name')"
              aria-label="Search for a Product"
              :get-result-value="getResultValue"
              @submit="handleSubmit"
              ref="autocomplete"
            />
          </b-form-group>
        </b-col>
        <!-- Details Product  -->
        <b-col md="12">
          <div class="table-responsive">
            <table class="table table-hover table-md">
              <thead>
                <tr>
                  <th scope="col">{{$t('ProductName')}}</th>
                  <th scope="col">{{$t('CodeProduct')}}</th>
                  <th scope="col">{{$t('Quantity')}}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-if="product.code === ''">
                  <td colspan="3">{{$t('NodataAvailable')}}</td>
                </tr>
                <tr v-else>
                  <td>{{product.name}}</td>
                  <td>{{product.code}}</td>
                  <td>
                    <input
                      v-model.number="barcode.qte"
                      class="form-control w-50 h-25"
                      id="qte"
                      type="number"
                      name="qte"
                    >
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </b-col>
        <b-col md="12">
          <button @click="submit()" type="submit" class="btn btn-primary btn-sm m-1">
            <i class="i-Edit"></i>
            {{$t('Updat')}}
          </button>
          <button @click="reset()" type="submit" class="btn btn-danger btn-sm m-1">
            <i class="i-Power-2"></i>
            {{$t('Reset')}}
          </button>
          <button
            @click="print_Bracode('print_barcode')"
            value="Print"
            type="submit"
            class="btn btn-light btn-sm pull-right m-1"
          >
            <i class="i-Billing"></i>
            {{$t('print')}}
          </button>
        </b-col>
      </b-row>
    </b-card>
    <div class="container" v-if="ShowCard">
      <b-row id="print_barcode">
        <b-col md="12">
          <div class="table-responsive">
            <div class="card-barcode">
              <div class="barcode-item" v-if="product.code !== ''" v-for="i in count">
                <div class="barcode-text p-1">
                  <h6>{{product.name}}</h6>
                </div>
                <barcode
                  class="barcode"
                  :format="product.Type_barcode"
                  :value="product.code"
                  textmargin="0"
                  fontoptions="bold"
                ></barcode>
              </div>
            </div>
          </div>
        </b-col>
      </b-row>
    </div>
  </div>
</template>

<script>
import VueBarcode from "vue-barcode";

export default {
  components: {
    barcode: VueBarcode
  },
  data() {
    return {
      isLoading: true,
      ShowCard: false,
      barcode: {
        product_id: "",
        warehouse_id: "",
        qte: 10
      },
      count: "",
      warehouses: [],
      submitStatus: null,
      products: [],
      product: {
        name: "",
        code: "",
        Type_barcode: ""
      }
    };
  },

  methods: {
    //------ Validate Form
    submit() {
      this.$refs.show_Barcode.validate().then(success => {
        if (!success) {
          return;
        } else {
          this.showBarcode();
        }
      });
    },

    //---Validate State Fields
    getValidationState({ dirty, validated, valid = null }) {
      return dirty || validated ? valid : null;
    },

    //------ Search Product with code or name
    search(input) {
      if (input.length < 1) {
        return [];
      }
      if (this.barcode.warehouse_id != "") {
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

    //------ Search Result value
    getResultValue(result) {
      return result.code + " " + "(" + result.name + ")";
    },

    //------ Submit Search Product
    handleSubmit(result) {
      this.product = {};
      if (this.product.code === result.code) {
        this.makeToast("warning", this.$t("AlreadyAdd"), this.$t("Warning"));
      } else {
        this.product.code = result.code;
        this.product.name = result.name;
        this.showBarcode();
      }

      this.$refs.autocomplete.value = "";
    },

    //------ Toast
    makeToast(variant, msg, title) {
      this.$root.$bvToast.toast(msg, {
        title: title,
        variant: variant,
        solid: true
      });
    },

    //------------------------------------ Get Products By warehouse -------------------------\\

    Get_Products_By_Warehouse(id) {
      axios
        .get("Products/Warehouse/" + id + "?stock=" + 0)
        .then(({ data }) => (this.products = data));
    },

    //---------------------------------Get Product Details ------------------------\\

    get_Product_Details(product_id) {
      axios.get("Products/" + product_id).then(response => {
        this.product.name = response.data.name;
        this.product.code = response.data.code;
        this.product.Type_barcode = response.data.Type_barcode;
      });
    },

    //-------------------------------------- Print Barcode -------------------------\\

    print_Bracode(DivID) {
      var disp_setting = "toolbar=yes,location=no,";
      disp_setting += "directories=yes,menubar=yes,";
      disp_setting += "scrollbars=yes,width=650, height=600, left=100, top=25";
      var content_vlue = document.getElementById(DivID).innerHTML;
      var docprint = window.open("", "", disp_setting);
      docprint.document.open();
      docprint.document.write("<head><title>Print Barcode</title>");
      docprint.document.write('<style type="text/css">body{ margin:0px;');
      docprint.document.write("font-family:verdana,Arial;color:#000;");
      docprint.document.write(
        "font-family:Verdana, Geneva, sans-serif; font-size:12px;}"
      );
      docprint.document.write(
        ".card-barcode{ width: 8.25in;height: 100%;display: block;margin: 10px auto;padding: 0.1in 0 0 0.1in;page-break-after: always;}"
      );
      docprint.document.write(
        ".barcode-item{ width: 2.48in;height: 208px;margin-left: 0.079in;padding-top: 0.05in;display: block;overflow: hidden;text-align: center;border: 1px dotted #CCC;font-size: 12px;line-height: 14px;text-transform: uppercase;float: left;}"
      );
      docprint.document.write(
        ".barcode-text{ padding-left: 10px; padding-right: 10px;}"
      );
      docprint.document.write("a{color:#000;text-decoration:none;} </style>");
      docprint.document.write('</head><body onLoad="self.print()">');
      docprint.document.write(content_vlue);
      docprint.document.write("</body></html>");
      docprint.document.close();
      docprint.focus();
    },

    //-------------------------------------- Show Barcode -------------------------\\
    showBarcode() {
      this.count = this.barcode.qte;
      this.ShowCard = true;
    },

    //---------------------- Event Select Warehouse ------------------------------\\
    Selected_Warehouse(value) {
      this.Get_Products_By_Warehouse(value);
    },

    //----------------------------------- GET Barcode Elements -------------------------\\
    Get_Elements: function() {
      axios
        .get("Products/Get_element/barcode")
        .then(response => {
          this.warehouses = response.data.warehouses;
          this.isLoading = false;
        })
        .catch(response => {
          setTimeout(() => {
            this.isLoading = false;
          }, 500);
        });
    },

    //----------------------------------- Reset Data -------------------------\\
    reset() {
      this.ShowCard = false;
      this.products = [];
      this.product.name = "";
      this.product.code = "";
      this.barcode.qte = 10;
      this.count = 10;
      this.barcode.warehouse_id = "";
    }
  }, //end Methods

  //-----------------------------Created function-------------------

  created: function() {
    this.Get_Elements();
  }
};
</script>