// app/javascript/home/age_range_slider.js
document.addEventListener('turbo:load', function() {
    const rangeSlider = document.getElementById('age-range-slider');
    const minAgeDisplay = document.getElementById('min-age-display');
    const maxAgeDisplay = document.getElementById('max-age-display');
    const ageRangeInput = document.getElementById('age-range-input');
    const sliderThumb = document.getElementById('age-range-thumb');
    const sliderTrack = document.getElementById('age-range-track');

    if (rangeSlider && minAgeDisplay && maxAgeDisplay && ageRangeInput && sliderThumb && sliderTrack) {
        // Inicializar valores
        let minAge = parseInt(rangeSlider.dataset.min);
        let maxAge = parseInt(rangeSlider.dataset.max);

        // Función para actualizar los valores y el campo oculto
        function updateAgeRange() {
            const values = rangeSlider.value.split(',');
            minAge = parseInt(values[0]);
            maxAge = parseInt(values[1]);

            if (minAge > maxAge) {
                minAge = maxAge;
            }

            if (maxAge < minAge) {
                maxAge = minAge;
            }

            minAgeDisplay.textContent = minAge;
            maxAgeDisplay.textContent = maxAge;
            ageRangeInput.value = `${minAge}-${maxAge}`;

            // Actualizar la posición del thumb y el color del track
            const minPercent = ((minAge - 18) / (99 - 18)) * 100;
            const maxPercent = ((maxAge - 18) / (99 - 18)) * 100;

            sliderThumb.style.left = `${maxPercent}%`;
            sliderTrack.style.width = `${maxPercent - minPercent}%`;
            sliderTrack.style.left = `${minPercent}%`;
        }

        // Event listener para el slider
        rangeSlider.addEventListener('input', function() {
            const values = rangeSlider.value.split(',');
            let minAge = parseInt(values[0]);
            let maxAge = parseInt(values[1]);

            if (minAge > maxAge) {
                minAge = maxAge;
            }

            if (maxAge < minAge) {
                maxAge = minAge;
            }

            rangeSlider.value = `${minAge},${maxAge}`;
            updateAgeRange();
        });

        // Inicializar al cargar la página
        updateAgeRange();
    }
});