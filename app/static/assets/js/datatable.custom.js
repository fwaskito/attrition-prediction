$(document).ready(function (){
	var table = $('#dataTable').DataTable({
		dom: 'Bfrtip',
		buttons: ['csv', 'excel', 'pdf'],
		responsive: true
	});

	// Handle click on "Expand All" button
	$('#btn-show-all-children').on('click', function(){
		table.rows(':not(.parent)').nodes().to$().find('td:first-child').trigger('click');
	});

	// Handle click on "Collapse All" button
	$('#btn-hide-all-children').on('click', function(){
		table.rows('.parent').nodes().to$().find('td:first-child').trigger('click');
	});
});
