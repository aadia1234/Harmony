tinymce.init({
    selector: 'textarea',
    plugins: 'anchor autolink charmap codesample emoticons image link lists media searchreplace table visualblocks wordcount checklist mediaembed casechange export formatpainter pageembed pagebreak linkchecker a11ychecker tinymcespellchecker permanentpen powerpaste advtable advcode editimage tinycomments tableofcontents footnotes mergetags autocorrect typography inlinecss',
    toolbar: 'undo redo | blocks fontfamily fontsize | bold italic underline strikethrough | link image media table mergetags | addcomment showcomments | spellcheckdialog a11ycheck typography | align lineheight pagebreak | checklist numlist bullist indent outdent | emoticons charmap | removeformat',
    height: 1500,
    toolbar_sticky: true,
    content_css: "document",
//    menubar: false,
    statusbar: false,
    skin: "oxide",
    tinycomments_mode: 'embedded',
    tinycomments_author: 'Author name',
    pagebreak_separator: "<hr>",
    pagebreak_split_block: true,
    mergetags_list: [
        { value: 'First.Name', title: 'First Name' },
        { value: 'Email', title: 'Email' },
    ]
});
