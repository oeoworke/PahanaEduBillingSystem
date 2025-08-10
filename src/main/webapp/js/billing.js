
document.addEventListener('DOMContentLoaded', function() {
    
    // Retrieving the key HTML elements in bill.jsp.
    const bookSelect = document.getElementById('bookId');
    const quantityInput = document.getElementById('quantity');
    const addToBillForm = document.querySelector('form[action*="addToCart"]');
    const createBillForm = document.querySelector('form[action*="createBill"]');

    /**
     * When the user selects a book, change the maximum value of the quantity input according to its stock (availability).
     */
    if (bookSelect && quantityInput) {
        bookSelect.addEventListener('change', function() {
            // Retrieving the selected option.
            const selectedOption = this.options[this.selectedIndex];
            // Retrieve the value of the data-stock attribute from the selected option.
            const stock = selectedOption.getAttribute('data-stock');

            if (stock) {
                // Set the max value of the quantity input to be equal to the stock.
                quantityInput.max = stock;
                
                // If the quantity entered by the user is greater than the stock, change it to 1.
                if (parseInt(quantityInput.value) > parseInt(stock)) {
                    quantityInput.value = 1;
                }
            } else {
                // If no book is selected, remove the max attribute.
                quantityInput.removeAttribute('max');
            }
        });
    }

    /**
     * Show a loading state when the "Add to Bill" button is clicked.
     */
    if (addToBillForm) {
        addToBillForm.addEventListener('submit', function() {
            const submitButton = this.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.disabled = true;
                submitButton.innerHTML = 'Adding...';
            }
        });
    }

    /**
     * Show a loading state when the "Create Final Bill" button is clicked.
     */
    if (createBillForm) {
        createBillForm.addEventListener('submit', function() {
            const submitButton = this.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.disabled = true;
                submitButton.innerHTML = 'Creating Bill...';
            }
        });
    }
});
