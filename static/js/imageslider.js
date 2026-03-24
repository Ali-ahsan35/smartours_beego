function initImageSlider() {
    document.querySelectorAll('.sp-property-card').forEach(card => {
        const imageSection = card.querySelector('.image-section');
        if (!imageSection) return;

        //right arrow button
        const nextBtn = document.createElement('button');
        nextBtn.className = 'slider-next-btn';
        nextBtn.innerHTML = '❯';
        nextBtn.style.cssText = `
            display: none;
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 20;
            background: rgba(255,255,255,0.9);
            border: none;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        `;
        imageSection.appendChild(nextBtn);

        // left arrow button
        const prevBtn = document.createElement('button');
        prevBtn.className = 'slider-prev-btn';
        prevBtn.innerHTML = '❮';
        prevBtn.style.cssText = `
            display: none;
            position: absolute;
            left: 8px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 20;
            background: rgba(255,255,255,0.9);
            border: none;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        `;
        imageSection.appendChild(prevBtn);

        // Show arrows on hover
        imageSection.addEventListener('mouseenter', () => {
            nextBtn.style.display = 'block';
        });
        imageSection.addEventListener('mouseleave', () => {
            nextBtn.style.display = 'none';
            prevBtn.style.display = 'none';
        });

        // Click next arrow
        nextBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            const propertyId = card.dataset.property_id;

            // Already loaded
            if (card.dataset.imagesLoaded === 'true') {
                navigateSlider(card, 1);
                return;
            }

            //fetch images from API
            fetch('/api/property/images?propertyId=' + propertyId)
                .then(res => res.json())
                .then(data => {
                    const images = data.Images || [];
                    if (images.length === 0) return;

                    // Store images in dataset
                    card.dataset.images = JSON.stringify(images);
                    card.dataset.currentIndex = '0';
                    card.dataset.imagesLoaded = 'true';

                    updateSliderImage(card);
                    prevBtn.style.display = 'block';
                    navigateSlider(card, 1);
                })
                .catch(err => console.error('Image fetch error:', err));
        });

        // Click prev arrow
        prevBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            navigateSlider(card, -1);
        });
    });
}

function navigateSlider(card, direction) {
    const images = JSON.parse(card.dataset.images || '[]');
    if (images.length === 0) return;

    let currentIndex = parseInt(card.dataset.currentIndex || '0');
    currentIndex = (currentIndex + direction + images.length) % images.length;
    card.dataset.currentIndex = currentIndex;

    updateSliderImage(card);

    // Show/hide prev button based on index
    const prevBtn = card.querySelector('.slider-prev-btn');
    const nextBtn = card.querySelector('.slider-next-btn');
    if (prevBtn) prevBtn.style.display = currentIndex === 0 ? 'none' : 'block';
    if (nextBtn) nextBtn.style.display = 'block';
}

function updateSliderImage(card) {
    const images = JSON.parse(card.dataset.images || '[]');
    const currentIndex = parseInt(card.dataset.currentIndex || '0');
    const imgEl = card.querySelector('.pt-featured-image');
    if (imgEl && images[currentIndex]) {
        imgEl.src = 'https://imgservice.ownerdirect.com/600x600/' + images[currentIndex];
    }

    // Update image counter
    let counter = card.querySelector('.slider-counter');
    if (!counter) {
        counter = document.createElement('span');
        counter.className = 'slider-counter';
        counter.style.cssText = `
            position: absolute;
            bottom: 8px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0,0,0,0.5);
            color: white;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 11px;
            z-index: 20;
        `;
        card.querySelector('.image-section').appendChild(counter);
    }
    counter.textContent = (currentIndex + 1) + ' / ' + images.length;
}