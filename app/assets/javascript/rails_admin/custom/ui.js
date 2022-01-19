$(document).on('ready pjax:success', function() {
  handleActiveBase();
  function handleActiveBase() {
    $('.sub-menu').each(function () {
      if ($(this).hasClass('active')) {
        $(this).parent().prev().addClass('active');
        $(this).parent().prev().addClass('open');
        $(this).parent().slideDown();
      }
    });
  }
});

$(document).on('rails_admin.dom_ready', function() {
    if($('#map').length > 0) {
        $("head").append(
            '<link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css"\n' +
            '      integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A=="\n' +
            '      crossOrigin="">'
        );
        const script = document.createElement("script");
        script.src = 'https://unpkg.com/leaflet@1.7.1/dist/leaflet.js';
        script.type = 'text/javascript';
        script.addEventListener('load', () => {
            let map = L.map( 'map', {
                center: [20.0, 5.0],
                minZoom: 2,
                zoom: 2
            });
            L.tileLayer( 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
                subdomains: ['a','b','c']
            }).addTo( map );
            let locations = $('#user_locations').data().content;
            locations.forEach(function (location, i) {
                L.circle([location.lat, location.lng], {
                    color: 'red',
                    fillColor: '#f03',
                    fillOpacity: 0.5,
                    radius: location.search_radius
                }).addTo(map);
                L.marker([location.lat, location.lng]).addTo(map);
            });
        });
        document.head.appendChild(script);
    }
});

$(function () {
  var width = $('.nav-stacked').width();
  $('.navbar-header').width(width);

    const array_menu = [];
    var lvl_1 = null;
  var count = 0;

  $('.sidebar-nav li').each(function (index, item) {
    if ($(item).hasClass('dropdown-header')) {
      lvl_1 = count++;
      array_menu[lvl_1] = []
    } else {
      $(item).addClass('sub-menu sub-menu-' + lvl_1);
    }
  });

  for (var i = 0; i <= array_menu.length; i++) {
    $('.sub-menu-' + i).wrapAll("<div class='sub-menu-container' />");
  }

  $('.sub-menu-container').hide();

  handleActiveBase();
  function handleActiveBase() {
    $('.sub-menu').each(function () {
      if ($(this).hasClass('active')) {
        $(this).parent().prev().addClass('active');
        $(this).parent().slideDown();
      }
    });
  }

  $('.dropdown-header').bind('click', function () {
    $('.dropdown-header').removeClass('open');
    $(this).addClass('open');

    $('.dropdown-header').removeClass('active');
    $('.sub-menu-container').stop().slideUp();
    $(this).toggleClass('active');
    $(this).next('.sub-menu-container').stop().slideDown();
  });
});