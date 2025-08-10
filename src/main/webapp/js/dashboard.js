/**
 *  Interactive functionalities for the Pahana Bookshop Dashboard.
 *  This includes hover effects, ripple animations, auto-hiding alerts, and clickable cards.
 */
document.addEventListener('DOMContentLoaded', function() {

    // --- Card Functionality ---
    const cards = document.querySelectorAll('.dashboard-card');
    cards.forEach(card => {
        // 1. Hover Effect 
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
            this.style.boxShadow = '0 10px 20px rgba(0,0,0,0.1)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = ''; // Reset to original CSS shadow
        });

        // 2. Clickable Card Functionality 
        card.addEventListener('click', function() {
            // Find the first 'Add', 'View', or 'Logout' button inside the card
            const primaryAction = card.querySelector('.btn-primary, .btn-danger');
            
            if (primaryAction && primaryAction.href) {
                // Redirect the user to the button's link (URL)
                window.location.href = primaryAction.href;
            }
        });
    });
    
    // --- Button Ripple Effect 
    const buttons = document.querySelectorAll('.btn');
    buttons.forEach(button => {
        button.addEventListener('click', function(e) {
            // Stop event propagation so that it doesn't affect the card's click listener
            e.stopPropagation();

            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;
            
            ripple.style.width = ripple.style.height = size + 'px';
            ripple.style.left = x + 'px';
            ripple.style.top = y + 'px';
            ripple.classList.add('ripple');
            
            // Remove old ripples
            const oldRipple = this.querySelector('.ripple');
            if(oldRipple) oldRipple.remove();

            this.appendChild(ripple);
        });
    });
    
    // --- Auto-hide Alerts 
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(() => {
                alert.remove();
            }, 300);
        }, 5000); // Hides after 5 seconds
    });
});

// --- Ripple Effect Styles
const style = document.createElement('style');
style.textContent = `
    .dashboard-card {
        cursor: pointer;
        transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
    }
    .btn {
        position: relative;
        overflow: hidden;
    }
    .ripple {
        position: absolute;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.6);
        transform: scale(0);
        animation: ripple-animation 0.4s ease-out;
        pointer-events: none;
    }
    @keyframes ripple-animation {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
    .alert {
        transition: opacity 0.3s ease, transform 0.3s ease;
    }
`;
document.head.appendChild(style);
