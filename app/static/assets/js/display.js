$(document).ready(function(){
	setTimeout(function() {
		$('#messageModal').modal('show');
	}, 1000);
});

$(window).on("load", function() {
	$('.home-page-content').fadeIn(2000);
	$('.history-page-content').fadeIn(1500);
	$('.prediction-page-content').fadeIn(1000);
});
