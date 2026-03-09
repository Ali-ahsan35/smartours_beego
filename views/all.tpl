<!DOCTYPE html>
<html>
<head>
    <title>{{.Country}} - Vacation Rentals</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    


    <link rel="stylesheet" href="/static/css/variables.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.123presto.com/prod/static/css/global-1.1.80.css"/>
    <link rel="stylesheet" type="text/css" href="https://cdn.123presto.com/prod/static/css/refine-1.1.80.css"/>
    <link rel="stylesheet" type="text/css" href="https://cdn.123presto.com/prod/static/css/tile-1.1.80.css"/>

    <style>
        .grid {
            display: grid !important;
            grid-template-columns: repeat(4, 1fr) !important;
            gap: 18px !important;
        }
        body {
            padding-left: 40px;
            padding-right: 30px;
        }

        .sp-property-card {
            width: 100% !important;
            margin: 0 !important;
            float: none !important;
        }

        @media (max-width: 1200px) { .grid { grid-template-columns: repeat(3, 1fr) !important; } }
        @media (max-width: 860px)  { .grid { grid-template-columns: repeat(2, 1fr) !important; } }
        @media (max-width: 520px)  { .grid { grid-template-columns: 1fr !important; } }
    </style>
</head>
<body>

    <div class="breadcrumb-share">
        <div class="refine-breadcrumb" id="js-breadcrumb">
            <span class="js-place-count">{{.PropertyCount}}+</span> Vacation Rentals Near {{.LocationName}} |
            <ol itemscope="itemscope" itemtype="http://schema.org/BreadcrumbList" style="display:inline; padding:0; margin:0; list-style:none;">
                {{range $i, $bc := .Breadcrumbs}}
                <li itemprop="itemListElement" itemscope="itemscope" itemtype="http://schema.org/ListItem" style="display:inline;">
                    <a itemprop="item" href="/all/{{index $bc "Slug"}}">
                        <span itemprop="name">{{index $bc "Name"}}</span>
                    </a>
                    <meta itemprop="Position" content="{{$i}}">
                </li>
                {{end}}
            </ol>
        </div>
        <div class="refine-share">
            <div class="share-button relative text-right">
                <button id="pt-share-expand" class="share-btn cursor-pointer js-close-share-btn" aria-label="Share">
                    Share
                </button>
            </div>
        </div>
    </div>

    <!-- Title + Subtitle -->
    <h1 class="title" id="js-location-name-h1">Trips to {{.LocationName}}</h1>
    <h2 class="category-sub-title" id="js-location-name-h2" style="display:inline; font-weight:400;">
        Plan Your Next Trip to {{.LocationName}} and explore unforgettable sights, local flavors, and exciting experiences.
    </h2>

    <!-- Filter Bar — same as refine page -->
    <div class="d-flex refine-filters align-item-center sp-flex-wrap justify-between pt-btn-wrap">
        <div id="pt-filter-wrap" class="refine-buttons">

            <div class="relative pt-datepicker" id="js-filter-dp-div">
                <div class="dp-inline" id="filter-dp">
                    <div class="datepicker-input sp-datepicker fl-btn">
                        <button id="standalone-dp">Dates</button>
                    </div>
                </div>
            </div>

            <div class="relative">
                <div class="filter-currency fl-btn" id="js-filter-currency-div">
                    <button class="cursor-pointer relative pt-price-btn" id="js-price-range">Price</button>
                </div>
            </div>

            <div class="relative">
                <div class="filter-guest-div fl-btn" id="js-filter-guest-div">
                    <button class="cursor-pointer relative pt-guest-btn" id="js-guest-picker">Guests</button>
                </div>
            </div>

            <div class="relative">
                <button class="cursor-pointer relative pt-filter-btn fl-btn more-fl-btn" id="filter-btn">More</button>
            </div>

        </div>
    </div>

    <!-- Property Grid -->
    <div class="category-content">
        <div class="grid" style="display:grid; grid-template-columns:repeat(4,1fr); gap:18px; padding:20px 0;">
            {{range .Items}}
            {{$item := .}}
            {{$prop := index $item "Property"}}
            {{$geo := index $item "GeoInfo"}}
            {{$partner := index $item "Partner"}}
            {{$id := index $item "ID"}}

            {{if $prop}}
            <div class="sp-property-card" data-property_id="{{$id}}">
                {{/*<small style="background:#013573;color:#fff;padding:2px 6px;font-size:10px;">{{$id}}</small>*/}}
                <!-- Image -->
                <div class="image-section relative" >
                    <div class="tiles-icons absolute">
                        <div class="tiles-btn fav-icon heart-btn" data-id="{{$id}}" title="Bookmark">♡</div>
                    </div>
                    <a rel="nofollow" target="_blank" class="sp-property-image" href="{{index $partner "URL"}}">
                        {{$imgName := index $prop "FeatureImage"}}
                        {{if $imgName}}
                        <img class="featured-image pt-featured-image"
                            src="https://imgservice.smartours.com/600x600/{{$imgName}}"
                            alt="{{index $prop "PropertyName"}}">
                        {{end}}
                        {{$price := index $prop "Price"}}
                        {{if $price}}
                        <span class="property-price js-price-value">
                            From BD ৳ {{printf "%.0f" (mul $price 120.0)}}
                        </span>
                        {{end}}
                    </a>
                </div>

                <!-- Details -->
                <div class="sp-property-details">

                    <!-- Rating + Type -->
                    <div class="property-review pt-property-review">
                        <div class="rating-review pt-rating-review">
                            <div class="reviews pt-reviews">
                                {{$score := index $prop "ReviewScore"}}
                                {{if $score}}
                                <span class="review-score">{{printf "%.1f" $score}}</span>
                                {{$counts := index $prop "Counts"}}
                                {{if $counts}}
                                <span class="review-count">({{index $counts "Reviews"}} Reviews)</span>
                                {{end}}
                                {{end}}
                            </div>
                        </div>
                        <span class="property-type">{{index $prop "PropertyType"}}</span>
                    </div>

                    <!-- Name -->
                    <div class="property-title">
                        <a title="{{index $prop "PropertyName"}}"
                            target="_blank"
                            href="{{index $partner "URL"}}"
                            class="pt-property-title">
                            {{index $prop "PropertyName"}}
                        </a>
                    </div>

                    <!-- Amenities -->
                    <div class="property-info">
                        <ul class="pt-amenities ellipsis">
                            {{$amenities := index $prop "TopAmenities"}}
                            {{range $amenities}}
                            <li class="pt-am-item" title="{{.}}">{{.}}</li>
                            {{end}}
                        </ul>
                    </div>

                    <!-- Location -->
                    <div class="property-location">
                        <ul class="pt-breadcrumbs">
                            {{$categories := index $geo "Categories"}}
                            {{range $categories}}
                            <li><a href="/all/{{index . "Slug"}}" target="_blank">{{index . "Name"}}</a></li>
                            {{end}}
                        </ul>
                    </div>

                    <!-- Bottom: logo + button + price -->
                    <div class="property-bottom">
                        <div class="property-brand">
                            {{$url := index $partner "URL"}}
                            <a rel="nofollow" class="pt-logo-wrap" href="{{$url}}" target="_blank">
                                {{if $url}}
                                    {{if contains $url "booking.com"}}
                                    <img loading="lazy" src="/static/img/partners-logo/booking.svg" height="14" width="80" class="pt-partner-logo" alt="Booking.com">
                                    {{else if contains $url "expedia.com"}}
                                    <img loading="lazy" src="/static/img/partners-logo/expedia_v2.svg" height="14" width="80" class="pt-partner-logo" alt="Expedia">
                                    {{else}}
                                    <img loading="lazy" src="/static/img/partners-logo/vrbo.svg" height="14" width="80" class="pt-partner-logo" alt="VRBO">
                                    {{end}}
                                {{end}}
                            </a>
                        </div>
                        <a rel="nofollow" target="_blank"
                            class="availability-button pt-availability"
                            href="{{index $partner "URL"}}">
                            View Availability
                        </a>
                    </div>

                </div>
            </div>
            {{end}}
            {{end}}
        </div>
    </div>

</body>
</html>