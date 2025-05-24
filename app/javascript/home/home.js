document.addEventListener('turbo:load', function() {
    const sidebar = document.getElementById('sidebar');
    const sidebarToggle = document.getElementById('sidebar-toggle');

    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('translate-x-0');
            sidebar.classList.toggle('-translate-x-full');
        });
    }

    let distanceInput = document.getElementById('profile_distance_range');
    let distanceValue = document.getElementById('distance-value');
    if (distanceInput) {
        distanceInput.addEventListener('input', function() {
            distanceValue.textContent = `${distanceInput.value} km`;
        });
    }

});