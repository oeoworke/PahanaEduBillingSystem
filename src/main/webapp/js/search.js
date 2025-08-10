// Search functionality
document.addEventListener('DOMContentLoaded', function() {
    const searchForm = document.querySelector('.search-form');
    const accNoInput = document.querySelector('input[name="accNo"]');
    
    if (searchForm && accNoInput) {
        // Auto-format account number
        accNoInput.addEventListener('input', function() {
            this.value = this.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
        });
        
        // Add search suggestions (if needed)
        setupSearchSuggestions();
        
        // Handle form submission
        searchForm.addEventListener('submit', function(e) {
            const submitButton = this.querySelector('button[type="submit"]');
            const originalText = submitButton.innerHTML;
            
            if (!accNoInput.value.trim()) {
                e.preventDefault();
                accNoInput.focus();
                accNoInput.setCustomValidity('Please enter an account number');
                accNoInput.reportValidity();
                return;
            }
            
            // Show loading state
            submitButton.disabled = true;
            submitButton.innerHTML = 'Searching...';
            
            // Reset after a delay (form will submit)
            setTimeout(() => {
                submitButton.disabled = false;
                submitButton.innerHTML = originalText;
            }, 1000);
        });
    }
    
    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + F to focus search
        if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
            e.preventDefault();
            const searchInput = document.querySelector('input[name="accNo"]');
            if (searchInput) {
                searchInput.focus();
                searchInput.select();
            }
        }
    });
});

function setupSearchSuggestions() {
    // This could be enhanced to show recent searches or customer suggestions
    const accNoInput = document.querySelector('input[name="accNo"]');
    
    if (accNoInput) {
        // Store recent searches in localStorage
        const recentSearches = JSON.parse(localStorage.getItem('recentSearches') || '[]');
        
        accNoInput.addEventListener('focus', function() {
            if (recentSearches.length > 0) {
                showSearchSuggestions(recentSearches, this);
            }
        });
        
        // Save search when form is submitted
        const searchForm = accNoInput.closest('form');
        if (searchForm) {
            searchForm.addEventListener('submit', function() {
                const searchValue = accNoInput.value.trim();
                if (searchValue && !recentSearches.includes(searchValue)) {
                    recentSearches.unshift(searchValue);
                    // Keep only last 5 searches
                    if (recentSearches.length > 5) {
                        recentSearches.pop();
                    }
                    localStorage.setItem('recentSearches', JSON.stringify(recentSearches));
                }
            });
        }
    }
}

function showSearchSuggestions(suggestions, input) {
    // Remove existing suggestions
    const existingSuggestions = document.querySelector('.search-suggestions');
    if (existingSuggestions) {
        existingSuggestions.remove();
    }
    
    if (suggestions.length === 0) return;
    
    const suggestionsDiv = document.createElement('div');
    suggestionsDiv.className = 'search-suggestions';
    
    suggestions.forEach(suggestion => {
        const suggestionItem = document.createElement('div');
        suggestionItem.className = 'suggestion-item';
        suggestionItem.textContent = suggestion;
        suggestionItem.addEventListener('click', function() {
            input.value = suggestion;
            suggestionsDiv.remove();
            input.closest('form').submit();
        });
        suggestionsDiv.appendChild(suggestionItem);
    });
    
    // Position suggestions below input
    const rect = input.getBoundingClientRect();
    suggestionsDiv.style.position = 'absolute';
    suggestionsDiv.style.top = (rect.bottom + window.scrollY) + 'px';
    suggestionsDiv.style.left = rect.left + 'px';
    suggestionsDiv.style.width = rect.width + 'px';
    
    document.body.appendChild(suggestionsDiv);
    
    // Remove suggestions when clicking outside
    setTimeout(() => {
        document.addEventListener('click', function(e) {
            if (!suggestionsDiv.contains(e.target) && e.target !== input) {
                suggestionsDiv.remove();
            }
        }, { once: true });
    }, 100);
}

// Add search styles
const searchStyles = document.createElement('style');
searchStyles.textContent = `
    .search-suggestions {
        background: white;
        border: 1px solid var(--medium-gray);
        border-radius: var(--border-radius);
        box-shadow: var(--shadow-lg);
        z-index: 1000;
        max-height: 200px;
        overflow-y: auto;
    }
    
    .suggestion-item {
        padding: 0.75rem;
        cursor: pointer;
        border-bottom: 1px solid var(--medium-gray);
        transition: background-color 0.2s ease;
    }
    
    .suggestion-item:hover {
        background-color: var(--light-gray);
    }
    
    .suggestion-item:last-child {
        border-bottom: none;
    }
`;
document.head.appendChild(searchStyles);