document.addEventListener('turbo:load', function() {
    const roleInput = document.getElementById("user-role");
    if (!roleInput) return;

    const buttons = document.querySelectorAll(".role-btn");

    buttons.forEach(btn => {
        btn.addEventListener("click", () => {
            const selectedRole = btn.dataset.role;
            roleInput.value = selectedRole;

            buttons.forEach(b => b.classList.remove("ring-2", "ring-pink-500"));
            btn.classList.add("ring-2", "ring-pink-500");
        });
    });
});