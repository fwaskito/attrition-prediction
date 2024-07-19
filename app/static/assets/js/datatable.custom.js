$(document).ready(function (){
	if ($('#dataTable').length) {
		var table = $('#dataTable').DataTable({
			dom: 'Bfrtip',
			buttons : [
				'csv',
				'excel',
				{
					extend: 'pdfHtml5',
					orientation: 'landscape',
					pageSize: 'LEGAL'
				}
			],
			responsive: true
		});
	} else {
		var employeeCols = [0,1,2,3,4,5,6,7,8,9,10,11,12,13];
		var table = $('#employeesDataTable').DataTable({
			dom: 'Bfrtip',
			buttons : [
				{
					extend: 'csvHtml5',
					exportOptions: {
						columns: employeeCols
					}
				},
				{
					extend: 'excelHtml5',
					exportOptions: {
						columns: employeeCols
					}
				},
				{
					extend: 'pdfHtml5',
					orientation: 'landscape',
					pageSize: 'LEGAL',
					exportOptions: {
						columns: employeeCols
					}
				}
			],
			responsive: true
		});
	}

	// Handle click on "Expand All" button
	$('#btn-show-all-children').on('click', function(){
		table.rows(':not(.parent)').nodes().to$().find('td:first-child').trigger('click');
	});

	// Handle click on "Collapse All" button
	$('#btn-hide-all-children').on('click', function(){
		table.rows('.parent').nodes().to$().find('td:first-child').trigger('click');
	});
});
