/**
 *  JavaScript to add interactive functionalities to all tables in Pahana Bookshop.
 *  This includes client-side searching, sorting, and custom delete confirmation.
 */
document.addEventListener('DOMContentLoaded', function() {
    addTableSearch();
    addTableSorting();
    addRowHoverEffects();
    addCustomDeleteConfirmation();
});

function addTableSearch() {
    const tables = document.querySelectorAll('.data-table');
    tables.forEach(table => {
        const searchContainer = document.createElement('div');
        searchContainer.className = 'table-search';
        searchContainer.innerHTML = `<input type="text" placeholder="Search in this table..." class="search-input">`;
        table.parentNode.insertBefore(searchContainer, table);
        
        const searchInput = searchContainer.querySelector('.search-input');
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr'));
        
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            let visibleRowsCount = 0;
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                const shouldShow = text.includes(searchTerm);
                row.style.display = shouldShow ? '' : 'none';
                if (shouldShow) visibleRowsCount++;
            });
            
            const noResultsRow = tbody.querySelector('.no-results');
            if (noResultsRow) noResultsRow.remove();

            if (visibleRowsCount === 0 && searchTerm) {
                const newNoResultsRow = document.createElement('tr');
                newNoResultsRow.className = 'no-results';
                newNoResultsRow.innerHTML = `<td colspan="${table.querySelector('th').colSpan || '100%'} " class="text-center">No results found for "${searchTerm}"</td>`;
                tbody.appendChild(newNoResultsRow);
            }
        });
    });
}

function addTableSorting() {
    document.querySelectorAll('.data-table th').forEach((header, index) => {
        if (header.textContent.toLowerCase().includes('action')) return;
        header.style.cursor = 'pointer';
        header.addEventListener('click', () => sortTable(header.closest('table'), index));
    });
}

function sortTable(table, columnIndex) {
    const tbody = table.querySelector('tbody');
    const rows = Array.from(tbody.querySelectorAll('tr'));
    const isAsc = table.querySelector(`th:nth-child(${columnIndex + 1})`).classList.contains('sort-asc');
    const direction = isAsc ? 'desc' : 'asc';

    rows.sort((a, b) => {
        const aText = a.cells[columnIndex].textContent.trim();
        const bText = b.cells[columnIndex].textContent.trim();
        const aNum = parseFloat(aText.replace(/[^\d.-]/g, ''));
        const bNum = parseFloat(bText.replace(/[^\d.-]/g, ''));

        let comparison = 0;
        if (!isNaN(aNum) && !isNaN(bNum)) {
            comparison = aNum - bNum;
        } else {
            comparison = aText.localeCompare(bText, undefined, { numeric: true });
        }
        return direction === 'asc' ? comparison : -comparison;
    });

    rows.forEach(row => tbody.appendChild(row));
    
    table.querySelectorAll('th').forEach(th => th.classList.remove('sort-asc', 'sort-desc'));
    table.querySelector(`th:nth-child(${columnIndex + 1})`).classList.add(`sort-${direction}`);
}

function addRowHoverEffects() {
    // This can be done more efficiently with CSS, but JS is also fine.
}


function addCustomDeleteConfirmation() {
    document.querySelectorAll('a[href*="delete"]').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault(); // Preventing the default behavior of the link.
            const deleteUrl = this.href;
            const itemName = this.closest('tr').cells[1].textContent.trim(); 
            
            showDeleteConfirmModal(
                `Are you sure you want to delete "${itemName}"?`,
                'This action cannot be undone. All related data will be permanently lost.',
                () => { window.location.href = deleteUrl; }
            );
        });
    });
}

/**
 * Create a custom confirmation modal and display it on the screen.
 * @param {string} title - Title of Modal
 * @param {string} message - Message from Modal
 * @param {function} onConfirm - A function that runs when the Confirm" button is pressed
 */
function showDeleteConfirmModal(title, message, onConfirm) {
    // If there is an old modal, remove it
    const existingModal = document.querySelector('.confirm-modal-overlay');
    if (existingModal) existingModal.remove();

    // Creating Modal HTML
    const modalOverlay = document.createElement('div');
    modalOverlay.className = 'confirm-modal-overlay';
    modalOverlay.innerHTML = `
        <div class="confirm-modal">
            <h3>${title}</h3>
            <p>${message}</p>
            <div class="modal-actions">
                <button class="btn btn-outline" id="cancel-btn">Cancel</button>
                <button class="btn btn-danger" id="confirm-btn">Confirm Delete</button>
            </div>
        </div>
    `;
    document.body.appendChild(modalOverlay);

    // Adding event listeners
    const confirmBtn = document.getElementById('confirm-btn');
    const cancelBtn = document.getElementById('cancel-btn');

    confirmBtn.onclick = () => {
        onConfirm();
        modalOverlay.remove();
    };
    
    cancelBtn.onclick = () => modalOverlay.remove();
    modalOverlay.onclick = (e) => {
        if (e.target === modalOverlay) {
            modalOverlay.remove();
        }
    };
}

// --- Dynamic Styles ---
const dynamicStyles = document.createElement('style');
dynamicStyles.textContent = `
    .table-search { padding: 1rem; background: white; border-bottom: 1px solid #e2e8f0; }
    .search-input { width: 100%; max-width: 300px; padding: 0.5rem; border: 1px solid #cbd5e1; border-radius: 0.375rem; }
    .search-input:focus { outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }
    th { position: relative; }
    th.sort-asc::after, th.sort-desc::after { position: absolute; right: 0.5rem; }
    th.sort-asc::after { content: ' ▲'; color: #3b82f6; }
    th.sort-desc::after { content: ' ▼'; color: #3b82f6; }
    .data-table tbody tr:hover { background-color: #f8fafc; }
    
    /* Custom Modal Styles */
    .confirm-modal-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.5); display: flex;
        justify-content: center; align-items: center; z-index: 1000;
    }
    .confirm-modal {
        background: white; padding: 2rem; border-radius: 0.5rem;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        max-width: 400px; text-align: center;
    }
    .confirm-modal h3 { font-size: 1.25rem; margin-bottom: 0.5rem; }
    .confirm-modal p { margin-bottom: 1.5rem; color: #64748b; }
    .modal-actions { display: flex; justify-content: center; gap: 1rem; }
`;
document.head.appendChild(dynamicStyles);
