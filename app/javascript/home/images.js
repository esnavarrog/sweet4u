document.addEventListener('turbo:load', function() {

    const checkboxes = document.querySelectorAll('.avatar-checkbox');

    checkboxes.forEach(function(checkbox) {
        checkbox.addEventListener('change', function() {
            checkboxes.forEach(function(otherCheckbox) {
                if (otherCheckbox !== checkbox) {
                    otherCheckbox.checked = false;
                }
            });
        });
    });
    function handleFileSelect(event) {
        const input = event.target;
        const previewId = input.dataset.previewId;
        const imageNumber = parseInt(input.dataset.imageNumber);
        const preview = document.getElementById(previewId);
        const addIconId = 'add_' + imageNumber;
        const removeIconId = 'remove_' + imageNumber;
        const addIcon = document.getElementById(addIconId);
        const removeIcon = document.getElementById(removeIconId);
        const file = input.files[0];

        if (file) {
            const reader = new FileReader();

            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.classList.remove('hidden');
                addIcon.classList.add('hidden');
                removeIcon.classList.remove('hidden');

                removeIcon.addEventListener('click', function(event) {
                    event.preventDefault();
                    preview.src = "";
                    preview.classList.add('hidden');
                    addIcon.classList.remove('hidden');
                    removeIcon.classList.add('hidden');
                    input.value = "";

                    // Mostrar el siguiente icono add
                    if (imageNumber < 6) {
                        const nextAddIcon = document.querySelector(`#add_${imageNumber + 1}`);
                        if (nextAddIcon) {
                            nextAddIcon.classList.remove('hidden');
                        }
                    }
                });
            }

            reader.readAsDataURL(file);

            // Mostrar el siguiente icono add
            if (imageNumber < 6) {
                const nextAddIcon = document.querySelector(`#add_${imageNumber + 1}`);
                if (nextAddIcon) {
                    nextAddIcon.classList.remove('hidden');
                }
            }
        } else {
            preview.src = "";
            preview.classList.add('hidden');
            addIcon.classList.remove('hidden');
            removeIcon.classList.add('hidden');
        }
    }

    document.querySelectorAll('.gallery-upload-input').forEach(function(input) {
        input.removeEventListener('change', handleFileSelect);
        input.addEventListener('change', handleFileSelect);
    });
});