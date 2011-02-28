$(document).ready(function() {
  $('a[rel*=facebox]').facebox({
    loadingImage : '/images/loading.gif',
    closeImage   : '/images/closelabel.png'
  }); 
  
  // var top = 10;
  // $(window).scroll(function() {
  //   if ($(window).scrollTop() > 270){
  //     $('.signature_box').stop().animate({ top: $(window).scrollTop() + top}, 2000);
  //   }           
  // });
  
});
