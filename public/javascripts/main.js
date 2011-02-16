$(document).ready(function(){
  search_value = $("input[class=sbox]").val();

  $("input[class=sbox]").focusin(function(){
    if($(this).val() == search_value)
      $(this).val("");
  });

  $("input[class=sbox]").focusout(function(){
    if($(this).val() == "")
      $(this).val(search_value);
  });
});
