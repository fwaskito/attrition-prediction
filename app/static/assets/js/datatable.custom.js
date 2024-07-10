$(document).ready(function (){

	var table = $('#example').DataTable({
		dom: 'Bfrtip',
		buttons: ['csv', 'excel', 'pdf']
	});

    // Handle click on "Expand All" button
	$('#btn-show-all-children').on('click', function(){
        // Expand row details
		table.rows(':not(.parent)').nodes().to$().find('td:first-child').trigger('click');
	});

    // Handle click on "Collapse All" button
	$('#btn-hide-all-children').on('click', function(){
        // Collapse row details
		table.rows('.parent').nodes().to$().find('td:first-child').trigger('click');
	});

	const theButton = document.querySelector(".button");

	theButton.addEventListener("click", () => {
		theButton.classList.add("button--loading");
	});
});


$(document).ready(function(){
	$('[data-toggle="tooltip"]').tooltip();
	var actions = $("table td:last-child").html();
// Delete row on delete button click
	$(document).on("click", ".delete", function(){
		$(this).parents("tr").remove();
		$(".add-new").removeAttr("disabled");
		var id = $(this).attr("id");
		var string = id;
		$.post("/ajax_delete", { string: string}, function(data) {
			$("#displaymessage").html(data);
			$("#displaymessage").show();
		});
	});
// update rec row on edit button click
	$(document).on("click", ".update", function(){
		var id = $(this).attr("id");
		var string = id;
		var txtname = $("#txtname").val();
		var txtdepartment = $("#txtdepartment").val();
		var txtphone = $("#txtphone").val();
		$.post("/ajax_update", { string: string,txtname: txtname, txtdepartment: txtdepartment, txtphone: txtphone}, function(data) {
			$("#displaymessage").html(data);
			$("#displaymessage").show();
		});


	});
// Edit row on edit button click
	$(document).on("click", ".edit", function(){
		$(this).parents("tr").find("td:not(:last-child)").each(function(i){
			if (i=='0'){
				var idname = 'txtname';
			}else if (i=='1'){
				var idname = 'txtdepartment';
			}else if (i=='2'){
				var idname = 'txtphone';
			}else{} 
			$(this).html('<input type="text" name="updaterec" id="' + idname + '" class="form-control" value="' + $(this).text() + '">');
		});
		$(this).parents("tr").find(".add, .edit").toggle();
		$(".add-new").attr("disabled", "disabled");
		$(this).parents("tr").find(".add").removeClass("add").addClass("update"); 
	});
});

$(document).ready(function(){
    $("#messageModal").modal('show');
});
