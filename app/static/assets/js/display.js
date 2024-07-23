$(document).ready(function(){
	setTimeout(function() {
		$('#messageModal').modal('show');
	}, 1000);
	setTimeout(function() {
		$('#mainToast').toast('show');
	}, 1500);
});

$(window).on("load", function() {
	$('.main-page-content').fadeIn(1000);
	$('.login-page-content').fadeIn(1000);
	$('.home-page-content').fadeIn(2000);
	$('.history-page-content').fadeIn(1500);
	$('.prediction-page-content').fadeIn(1000);
});

const scrollSpy = new bootstrap.ScrollSpy(document.body, {
	target: '#guideNavbar'
  })