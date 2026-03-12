// Override the apply filter for all page — redirect to refine instead
document.getElementById('js-apply-filter').addEventListener('click', function() {
    const checkedAmenities = [];
    document.querySelectorAll('#js-dynamic-amenities-filter input[type=checkbox]:checked').forEach(cb => {
        checkedAmenities.push(cb.value);
    });
    if (document.getElementById('amenity-11').checked) {
        checkedAmenities.push('11');
    }

    const ecoFriendly  = document.getElementById('js-eco-friendly').checked;
    const minPriceBDT  = parseInt(document.getElementById('js-min-price').value) || 244;
    const maxPriceBDT  = parseInt(document.getElementById('js-max-price').value) || 122096;
    const guests       = document.getElementById('js-guest-count').textContent;

    // Build search from current page location
    const search = window.locationName || document.title;

    const params = new URLSearchParams();
    params.set('search', search);
    params.set('order', '1');

    if (checkedAmenities.length > 0) {
        params.set('amenities', [...new Set(checkedAmenities)].join('-'));
    }
    if (ecoFriendly) {
        params.set('ecoFriendly', 'true');
    }
    if (minPriceBDT > 244 || maxPriceBDT < 122096) {
        params.set('amount', minPriceBDT + '-' + maxPriceBDT);
        params.set('selectedCurrency', 'BDT');
    }
    if (guests !== '0') {
        params.set('pax', guests);
    }

    window.location.href = '/refine?' + params.toString();
});