$(document).ready(function() {
  $('a[rel*=facebox]').facebox({
    loadingImage : '/images/loading.gif',
    closeImage   : '/images/closelabel.png'
  }); 

  //$("#signature_municipality_id, #signature_municipality_of_birth_id").selectbox();

  $("#ilp_signature_province_id").selectbox({
    onChange: function () {
      var id_value_string = $(this).val();
      if (id_value_string == "") {
        // if the id is empty remove all the sub_selection options from being selectable and do not do any ajax
        $("select#ilp_signature_municipality_id option").remove();
        var row = "<option value=\"" + "" + "\">" + "" + "</option>";
        $(row).appendTo("select#ilp_signature_municipality_id");
      }
      else {
        // Send the request and update sub category dropdown
        $.ajax({
          dataType: "json",
          cache: false,
          url: '/province/municipalities_for_provinceid/' + id_value_string,
          timeout: 2000,
          error: function(XMLHttpRequest, errorTextStatus, error){
            alert("Failed to submit : "+ errorTextStatus+" ;"+error);
          },
          success: function(data){
            // Disable selectbox functionality in order to be able to enable it again with new values
            $("#ilp_signature_municipality_id").selectbox("detach");
            // Clear all options from sub category select
            $("select#ilp_signature_municipality_id option").remove();
            //put in a empty default line
            var row = "<option value=\"" + "" + "\">" + "" + "</option>";
            $(row).appendTo("select#ilp_signature_municipality_id");                        
            // Fill sub category select
            $.each(data, function(i, j){
              row = "<option value=\"" + j.municipality.id + "\">" + j.municipality.name + "</option>";  
              $(row).appendTo("select#ilp_signature_municipality_id");                    
            });
            $("#signature_municipality_id").selectbox();       
          }
        });
      };
    }
  });
  
  $("#ilp_signature_province_of_birth_id").selectbox({
    onChange: function () {
      var id_value_string = $(this).val();
      if (id_value_string == "") {
        // if the id is empty remove all the sub_selection options from being selectable and do not do any ajax
        $("select#ilp_signature_municipality_of_birth_id option").remove();
        var row = "<option value=\"" + "" + "\">" + "" + "</option>";
        $(row).appendTo("select#ilp_signature_municipality_of_birth_id");
      }
      else {
        // Send the request and update sub category dropdown
        $.ajax({
          dataType: "json",
          cache: false,
          url: '/province/municipalities_for_provinceid/' + id_value_string,
          timeout: 2000,
          error: function(XMLHttpRequest, errorTextStatus, error){
            alert("Failed to submit : "+ errorTextStatus+" ;"+error);
          },
          success: function(data){
            // Disable selectbox functionality in order to be able to enable it again with new values
            $("#ilp_signature_municipality_of_birth_id").selectbox("detach");
            // Clear all options from sub category select
            $("select#ilp_signature_municipality_of_birth_id option").remove();
            //put in a empty default line
            var row = "<option value=\"" + "" + "\">" + "" + "</option>";
            $(row).appendTo("select#ilp_signature_municipality_of_birth_id");                        
            // Fill sub category select
            $.each(data, function(i, j){
              row = "<option value=\"" + j.municipality.id + "\">" + j.municipality.name + "</option>";  
              $(row).appendTo("select#ilp_signature_municipality_of_birth_id");
            });
            $("#ilp_signature_municipality_of_birth_id").selectbox();
          }
        });
      };
    }
  });

  $("#ilp_signature_municipality_id").selectbox();

  $("#ilp_signature_municipality_of_birth_id").selectbox();
});