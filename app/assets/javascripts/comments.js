var commentFormId = '';

function closeCommentForm(formId) {
  const oldForm = document.getElementById(formId);
  if (oldForm) { 
    oldForm.remove(); 
    commentFormId = '';
   };
};

function handleEditClick(blogId, commentId ) {
  if (commentFormId) {
    // remove opened Form
    const oldForm = document.getElementById(commentFormId);
    oldForm.remove();
  }
  // add new form
  commentFormId = `form-${blogId}-${commentId}`
  const form = formBuilder(blogId, commentId, commentFormId)

  const card = document.getElementById(`collapse-${blogId}-${commentId}`);
  card.appendChild(form)
  // insertAfter(form, card);
}

function insertAfter(newNode, referenceNode) {
    referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling);
}

function formBuilder(blogId, commentId, formId){
  const formData = {
    bodyLabel: {
      tag: 'label',
      attrs: {
        value: 'body',
        for: 'body',
      }
    },
    bodyInput: {
      tag: 'textarea',
      attrs: {
        name: 'body'
      }
    },
    submit: {
      tag: 'input',
      attrs: {
        type: 'submit',
        class: 'btn btn-primary',
        value: 'Update',
      }
    },
    cancel: {
      tag: 'input',
      attrs: {
        type: 'button',
        class: 'btn btn-secondary',
        value: 'Cancel',
        // onclick: `closeCommentForm('${formId}')`,
        'data-toggle': "collapse",
        'data-target': `#collapse-${blogId}-${commentId}`,'aria-expanded': "false",
        'aria-controls': `#collapse-${blogId}-${commentId}`,
      }
    }
  };

  const form = document.createElement("form");
  form.setAttribute('id', formId)
  form.classList.add('comment-form');
  form.setAttribute('action', `/blogs/${blogId}/comments/${commentId}.json`)
  const fields = Object.values(formData).map(fieldData => {
    const f = document.createElement(fieldData.tag);
    const attrs = Object.keys(fieldData.attrs)
    attrs.forEach(key => {
      f.setAttribute(key, fieldData.attrs[key])
    });
    return f
  });

  fields.forEach(f => {
    form.appendChild(f);
  })

  form.addEventListener("submit", handleSubmitComment)
  return form
}


function handleSubmitComment(e){
  const csrfToken = document.querySelector("[name='csrf-token']").content
  e.preventDefault();
  const data = Object.fromEntries(new FormData(e.target).entries());
  fetch(e.target.action, {
    method: 'PUT',
    headers: {
      "X-CSRF-Token": csrfToken,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data)
  }).then(res => {
    if (!res.ok) { throw res};
    alert("Comment submitted")
    closeCommentForm(e.target.id);
    res.json().then(data => {
      updateComment(data)
    }).catch(err => {
      console.log('error when pasrsing response: ', err)
    })
  }).catch(err => {
    console.log(err)
  })
};

function updateComment(data) {
  const card = document.getElementById(`${data.blog_id}-${data.id}`)
  if (!card) return;
  card.getElementsByClassName('blog-comments__comment-card-body')[0].innerHTML = data.body
  card.getElementsByClassName('blog-comments__comment-card-updated-time')[0].innerHTML = `Updated: ${DateHelper.time_ago_in_words(data.updated_at)}`
}
