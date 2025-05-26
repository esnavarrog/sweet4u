document.addEventListener('turbo:load', function() {
    let distanceInput = document.getElementById('profile_distance_range');
    let distanceValue = document.getElementById('distance-value');
    if (distanceInput) {
        distanceInput.addEventListener('input', function() {
            distanceValue.textContent = `${distanceInput.value} km`;
        });
    }
});