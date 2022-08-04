// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/


function handleEditClick(blogId, commentId) {
  const form = document.getElementById('comment-form')
  form.classList.remove('hidden')

  form.addEventListener("submit", function(event){
    event.preventDefault()
    console.log(event.target.body.value, commentId)

  // fetch('http://example.com/movies.json')
  //   .then((response) => response.json())
  //   .then((data) => console.log(data));
  });
}


// fetch('http://example.com/movies.json')
//   .then((response) => response.json())
//   .then((data) => console.log(data));
