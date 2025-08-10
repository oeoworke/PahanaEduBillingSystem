document.addEventListener('DOMContentLoaded', function() {

    // Phone Number Verification (10 digits only)
    const phoneInput = document.querySelector('input[name="phone"]');
    if (phoneInput) {
        phoneInput.addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, ''); // Eliminating other than numbers
            if (this.value.length > 10) {
                this.value = this.value.slice(0, 10);
            }
        });
    }

    // Customer ID / Account Number Verification
    const accNoInput = document.querySelector('input[name="accNo"]');
    if (accNoInput) {
        accNoInput.addEventListener('input', function() {
            this.value = this.value.replace(/[^a-zA-Z0-9]/g, '').toUpperCase();
        });
    }

    // Price Validation (must be greater than 0)
    const priceInput = document.querySelector('input[name="price"]');
    if (priceInput) {
        priceInput.addEventListener('input', function() {
            if (parseFloat(this.value) < 0) {
                this.value = 0;
            }
        });
    }

    // Stock Check (can be 0 or more)
    const stockInput = document.querySelector('input[name="stock"]');
    if (stockInput) {
        stockInput.addEventListener('input', function() {
            if (parseInt(this.value) < 0) {
                this.value = 0;
            }
        });
    }

    // Showing loading state on form submission
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function() {
            const submitButton = form.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.disabled = true;
                submitButton.innerHTML = 'Saving...';
            }
        });
    });
});
