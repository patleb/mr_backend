$(document).ready (content) ->

  content = if content then content else $('form')

  return unless content.length # don't waste time otherwise

  # fileupload

  # https://github.com/Simonwep/pickr

  content.find('[data-fileupload]').each ->
    input = this
    $(this).on 'click', ".delete input[type='checkbox']", ->
      $(input).children('.toggle').toggle('slow')

  # fileupload-preview

  content.find('[data-fileupload]').change ->
    input = this
    image_container = $("#" + input.id).parent().children(".preview")
    unless image_container.length
      image_container = $("#" + input.id).parent().prepend($('<img />').addClass('preview').addClass('img-thumbnail')).find('img.preview')
      image_container.parent().find('img:not(.preview)').hide()
    ext = $("#" + input.id).val().split('.').pop().toLowerCase()
    if input.files and input.files[0] and $.inArray(ext, ['gif','png','jpg','jpeg','bmp']) != -1
      reader = new FileReader()
      reader.onload = (e) ->
        image_container.attr "src", e.target.result
      reader.readAsDataURL input.files[0]
      image_container.show()
    else
      image_container.hide()
