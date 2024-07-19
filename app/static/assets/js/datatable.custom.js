$(document).ready(function (){
	var table = $('#example').DataTable({
		dom: 'Bfrtip',
		buttons: ['csv', 'excel', 'pdf'],
		responsive: true
	});
});
