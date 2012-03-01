$(function() {
$( "#event_scheduled_at" ).datepicker({ dateFormat: "dd/mm/yy" });
});

function mark_selected(event_id,candidate_id) {
	$.ajax({
		url : "/events/"+event_id+"/candidates/"+candidate_id+"/mark_selected",
		dataType : 'script',
		type : 'get',
		data : "candidate_id="+candidate_id
	});
}

function mark_rejected(event_id,candidate_id) {
	$.ajax({
		url : "/events/"+event_id+"/candidates/"+candidate_id+"/mark_rejected",
		dataType : 'script',
		type : 'get',
		data : "candidate_id="+candidate_id
	});
	
}

function mark_candidate(candidate_id) {
	$.ajax({
		url : "/candidates/"+candidate_id+"/mark_star",
		dataType : 'script',
		type : 'get',
		data : "candidate_id="+ candidate_id
	});
}

function search_num(search_val) {
  if(!(search_val == "")) {
    if(!(search_val.match(/^\d+$/))) {
      document.getElementById("error").innerHTML = "Please Enter A Number!"
      return false
    }
  } else {
    document.getElementById("error").innerHTML = "Search field cannot be empty!"
    return false
  }
  
   $.ajax({
     url : "/find_search_data",
     dataType : 'script',
     type : 'get',
     data : "roll_num="+search_val
   });
}

function s_category(ele) {
	$.ajax({
		url : "/candidates/find_category",
		dataType : 'script',
		type : 'get',
		data : "category="+$("#category").val()+"&page_type="+ele
	});
}

function show_map() {
  $.ajax({
    url : "/change_map_location",
    dataType : 'script',
    type : 'get',
    data : "location="+$("#event_location").attr("value")
  });
}
 
// function mark_attendance(event_id) {
//   $.each($("input:checked"), function(i, ele){ console.log($(ele).val());})
//   $.ajax({
//     url : ""/events/"+event_id+"/candidates/"+candidate_id+"/mark_selected"",
//     dataType : 'script',
//     type : 'get',
//     data : "roll_num="+search_val
//   });
// } 
