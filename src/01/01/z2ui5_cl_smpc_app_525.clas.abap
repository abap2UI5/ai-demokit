" @keywords list sap.m listgrowingupwards standardlistitem
" @summary The Upwards Growing
CLASS z2ui5_cl_smpc_app_525 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name         TYPE string,
             description  TYPE string,
             price        TYPE string,
             currencycode TYPE string,
             initial      TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_525 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        " groupFunction returns the first letter of Name - a control-returning
        " grouping callback has no backend equivalent, so the letter is a model
        " field and the binding groups by it, then sorts by Name inside the group
        )->ele( `List`
            )->a( n = `growing`             v = `true`
            )->a( n = `growingThreshold`    v = `10`
            )->a( n = `growingDirection`    v = `Upwards`
            )->a( n = `busyIndicatorDelay`  v = `200`
            )->a( n = `enableBusyIndicator` v = `true`
            )->a( n = `growingTriggerText`  v = `Previous Products`
            )->a( n = `noDataText`          v = `No products available`
            )->a( n = `items`               v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: [\{ path: 'INITIAL', descending: false, group: true \}, \{ path: 'NAME', descending: false \}] \}|

            )->tag( `StandardListItem`
                )->a( n = `title`       v = `{NAME}`
                )->a( n = `description` v = `{DESCRIPTION}`
                )->a( n = `info`        v = `{PRICE} {CURRENCYCODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the mock server's ProductCollection; INITIAL is the first letter of Name,
    " which is what the original's groupFunction returns
    DATA temp1 TYPE z2ui5_cl_smpc_app_525=>ty_t_product.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-name = `Notebook Basic 15`.
    temp2-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp2-price = `956`.
    temp2-currencycode = `EUR`.
    temp2-initial = `N`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 17`.
    temp2-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp2-price = `1249`.
    temp2-currencycode = `EUR`.
    temp2-initial = `N`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 18`.
    temp2-description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp2-price = `1570`.
    temp2-currencycode = `EUR`.
    temp2-initial = `N`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 19`.
    temp2-description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp2-price = `1650`.
    temp2-currencycode = `EUR`.
    temp2-initial = `N`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault`.
    temp2-description = `Digital Organizer with State-of-the-Art Storage Encryption`.
    temp2-price = `299`.
    temp2-currencycode = `EUR`.
    temp2-initial = `I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 15`.
    temp2-description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp2-price = `1999`.
    temp2-currencycode = `EUR`.
    temp2-initial = `N`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 17`.
    temp2-description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp2-price = `2299`.
    temp2-currencycode = `EUR`.
    temp2-initial = `N`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault Net`.
    temp2-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`.
    temp2-price = `459`.
    temp2-currencycode = `EUR`.
    temp2-initial = `I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault SAT`.
    temp2-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`.
    temp2-price = `149`.
    temp2-currencycode = `EUR`.
    temp2-initial = `I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Easy`.
    temp2-description = `32 GB Digital Assistant with high-resolution color screen`.
    temp2-price = `1679`.
    temp2-currencycode = `EUR`.
    temp2-initial = `C`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Senior`.
    temp2-description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output`.
    temp2-price = `512`.
    temp2-currencycode = `EUR`.
    temp2-initial = `C`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-I`.
    temp2-description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`.
    temp2-price = `230`.
    temp2-currencycode = `EUR`.
    temp2-initial = `E`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-II`.
    temp2-description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`.
    temp2-price = `285`.
    temp2-currencycode = `EUR`.
    temp2-initial = `E`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-III`.
    temp2-description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`.
    temp2-price = `345`.
    temp2-currencycode = `EUR`.
    temp2-initial = `E`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Basic`.
    temp2-description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`.
    temp2-price = `399`.
    temp2-currencycode = `EUR`.
    temp2-initial = `F`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Future`.
    temp2-description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`.
    temp2-price = `430`.
    temp2-currencycode = `EUR`.
    temp2-initial = `F`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XL`.
    temp2-description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`.
    temp2-price = `1230`.
    temp2-currencycode = `EUR`.
    temp2-initial = `F`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Professional Eco`.
    temp2-description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`.
    temp2-price = `830`.
    temp2-currencycode = `EUR`.
    temp2-initial = `L`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Basic`.
    temp2-description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`.
    temp2-price = `490`.
    temp2-currencycode = `EUR`.
    temp2-initial = `L`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Laser Allround`.
    temp2-description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`.
    temp2-price = `349`.
    temp2-currencycode = `EUR`.
    temp2-initial = `L`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Color`.
    temp2-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet`.
    temp2-price = `139`.
    temp2-currencycode = `EUR`.
    temp2-initial = `U`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Mobile`.
    temp2-description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office`.
    temp2-price = `99`.
    temp2-currencycode = `EUR`.
    temp2-initial = `U`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ultra Jet Super Highspeed`.
    temp2-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`.
    temp2-price = `170`.
    temp2-currencycode = `EUR`.
    temp2-initial = `U`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Print`.
    temp2-description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)`.
    temp2-price = `99`.
    temp2-currencycode = `EUR`.
    temp2-initial = `M`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Multi Color`.
    temp2-description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)`.
    temp2-price = `119`.
    temp2-currencycode = `EUR`.
    temp2-initial = `M`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Mouse`.
    temp2-description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`.
    temp2-price = `9`.
    temp2-currencycode = `EUR`.
    temp2-initial = `C`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Speed Mouse`.
    temp2-description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)`.
    temp2-price = `7`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Track Mouse`.
    temp2-description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play`.
    temp2-price = `11`.
    temp2-currencycode = `EUR`.
    temp2-initial = `T`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergonomic Keyboard`.
    temp2-description = `Ergonomic USB Keyboard for Desktop, Plug&Play`.
    temp2-price = `14`.
    temp2-currencycode = `EUR`.
    temp2-initial = `E`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Internet Keyboard`.
    temp2-description = `Corded Keyboard with special keys for Internet Usability, USB`.
    temp2-price = `16`.
    temp2-currencycode = `EUR`.
    temp2-initial = `I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Media Keyboard`.
    temp2-description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB`.
    temp2-price = `26`.
    temp2-currencycode = `EUR`.
    temp2-initial = `M`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mousepad`.
    temp2-description = `Nice mouse pad with ITelO Logo`.
    temp2-price = `6.99`.
    temp2-currencycode = `EUR`.
    temp2-initial = `M`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Mousepad`.
    temp2-description = `Ergonomic mouse pad with ITelO Logo`.
    temp2-price = `8.99`.
    temp2-currencycode = `EUR`.
    temp2-initial = `E`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Designer Mousepad`.
    temp2-description = `ITelO Mousepad Special Edition`.
    temp2-price = `12.99`.
    temp2-currencycode = `EUR`.
    temp2-initial = `D`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Universal card reader`.
    temp2-description = `Universal card reader`.
    temp2-price = `14`.
    temp2-currencycode = `EUR`.
    temp2-initial = `U`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Proctra X`.
    temp2-description = `Proctra X: PCI-E GDDR5 3072MB`.
    temp2-price = `70.9`.
    temp2-currencycode = `EUR`.
    temp2-initial = `P`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gladiator MX`.
    temp2-description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise`.
    temp2-price = `81.7`.
    temp2-currencycode = `EUR`.
    temp2-initial = `G`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX`.
    temp2-description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized`.
    temp2-price = `101.2`.
    temp2-currencycode = `EUR`.
    temp2-initial = `H`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Hurricane GX/LN`.
    temp2-description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.`.
    temp2-price = `139.99`.
    temp2-currencycode = `EUR`.
    temp2-initial = `H`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Photo Scan`.
    temp2-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth`.
    temp2-price = `129`.
    temp2-currencycode = `EUR`.
    temp2-initial = `P`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Scan`.
    temp2-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility`.
    temp2-price = `89`.
    temp2-currencycode = `EUR`.
    temp2-initial = `P`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    temp2-description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp2-price = `169`.
    temp2-currencycode = `EUR`.
    temp2-initial = `J`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Jet Scan Professional`.
    temp2-description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp2-price = `189`.
    temp2-currencycode = `EUR`.
    temp2-initial = `J`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copymaster`.
    temp2-description = `Copymaster`.
    temp2-price = `1499`.
    temp2-currencycode = `EUR`.
    temp2-initial = `C`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Surround Sound`.
    temp2-description = `PC multimedia speakers - 5 Watt (Total)`.
    temp2-price = `39`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Blaster Extreme`.
    temp2-description = `PC multimedia speakers - 10 Watt (Total) - 2-way`.
    temp2-price = `26`.
    temp2-currencycode = `EUR`.
    temp2-initial = `B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Sound Booster`.
    temp2-description = `PC multimedia speakers - optimized for Blutooth/A2DP`.
    temp2-price = `45`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    temp2-description = `5.1 Headset, 40 Hz-20 kHz, Wireless`.
    temp2-price = `49`.
    temp2-currencycode = `EUR`.
    temp2-initial = `L`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound 5.1`.
    temp2-description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`.
    temp2-price = `39`.
    temp2-currencycode = `EUR`.
    temp2-initial = `L`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Lovely Sound Stereo`.
    temp2-description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`.
    temp2-price = `29`.
    temp2-currencycode = `EUR`.
    temp2-initial = `L`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Office`.
    temp2-description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)`.
    temp2-price = `89.9`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Design`.
    temp2-description = `Complete package, 1 User, Image editing, processing`.
    temp2-price = `79.9`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Network`.
    temp2-description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation`.
    temp2-price = `69`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Multimedia`.
    temp2-description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`.
    temp2-price = `77`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Games`.
    temp2-description = `Complete package, 1 User, various games for amusement, logic, action, jump&run`.
    temp2-price = `55`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Internet Antivirus`.
    temp2-description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`.
    temp2-price = `29`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Firewall`.
    temp2-description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime`.
    temp2-price = `34`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smart Money`.
    temp2-description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want`.
    temp2-price = `29.9`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Lock`.
    temp2-description = `Robust 3m anti-burglary protection for your laptop computer`.
    temp2-price = `8.9`.
    temp2-currencycode = `EUR`.
    temp2-initial = `P`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Lock`.
    temp2-description = `Robust 1m anti-burglary protection for your desktop computer`.
    temp2-price = `6.9`.
    temp2-currencycode = `EUR`.
    temp2-initial = `N`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Web cam reality`.
    temp2-description = `Color webcam, color, High-Speed USB`.
    temp2-price = `39`.
    temp2-currencycode = `EUR`.
    temp2-initial = `W`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Screen clean`.
    temp2-description = `10 separately packed screen wipes`.
    temp2-price = `2.3`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Fabric bag professional`.
    temp2-description = `Notebook bag, plenty of room for stationery and writing materials`.
    temp2-price = `31`.
    temp2-currencycode = `EUR`.
    temp2-initial = `F`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router`.
    temp2-description = `Wireless DSL Router (available in blue, black and silver)`.
    temp2-price = `49`.
    temp2-currencycode = `EUR`.
    temp2-initial = `W`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater`.
    temp2-description = `Wireless DSL Router / Repeater (available in blue, black and silver)`.
    temp2-price = `59`.
    temp2-currencycode = `EUR`.
    temp2-initial = `W`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    temp2-description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)`.
    temp2-price = `69`.
    temp2-currencycode = `EUR`.
    temp2-initial = `W`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `USB Stick`.
    temp2-description = `USB 2.0 High-Speed 64 GB`.
    temp2-price = `35`.
    temp2-currencycode = `EUR`.
    temp2-initial = `U`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Travel Adapter`.
    temp2-description = `Universal Travel Adapter`.
    temp2-price = `79`.
    temp2-currencycode = `EUR`.
    temp2-initial = `T`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    temp2-description = `Cordless Bluetooth Keyboard with English keys`.
    temp2-price = `29`.
    temp2-currencycode = `EUR`.
    temp2-initial = `C`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat XXL`.
    temp2-description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm`.
    temp2-price = `1430`.
    temp2-currencycode = `EUR`.
    temp2-initial = `F`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Pocket Mouse`.
    temp2-description = `Portable pocket Mouse with retracting cord`.
    temp2-price = `23`.
    temp2-currencycode = `EUR`.
    temp2-initial = `P`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `PC Power Station`.
    temp2-description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro`.
    temp2-price = `2399`.
    temp2-currencycode = `EUR`.
    temp2-initial = `P`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Laptop 1516`.
    temp2-description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro`.
    temp2-price = `989`.
    temp2-currencycode = `EUR`.
    temp2-initial = `A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Astro Phone 6`.
    temp2-description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black`.
    temp2-price = `649`.
    temp2-currencycode = `EUR`.
    temp2-initial = `A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Benda Laptop 1408`.
    temp2-description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro`.
    temp2-price = `976`.
    temp2-currencycode = `EUR`.
    temp2-initial = `B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Bending Screen 21HD`.
    temp2-description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp2-price = `250`.
    temp2-currencycode = `EUR`.
    temp2-initial = `B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Broad Screen 22HD`.
    temp2-description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp2-price = `270`.
    temp2-currencycode = `EUR`.
    temp2-initial = `B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cerdik Phone 7`.
    temp2-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    temp2-initial = `C`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 10.5`.
    temp2-description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    temp2-initial = `C`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Cepat Tablet 8`.
    temp2-description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor`.
    temp2-price = `529`.
    temp2-currencycode = `EUR`.
    temp2-initial = `C`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Basic`.
    temp2-description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity`.
    temp2-price = `5000`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Professional`.
    temp2-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity`.
    temp2-price = `15000`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Server Power Pro`.
    temp2-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity`.
    temp2-price = `25000`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Basic`.
    temp2-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8`.
    temp2-price = `600`.
    temp2-currencycode = `EUR`.
    temp2-initial = `F`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Family PC Pro`.
    temp2-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp2-price = `900`.
    temp2-currencycode = `EUR`.
    temp2-initial = `F`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster`.
    temp2-description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp2-price = `1200`.
    temp2-currencycode = `EUR`.
    temp2-initial = `G`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Gaming Monster Pro`.
    temp2-description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8`.
    temp2-price = `1700`.
    temp2-currencycode = `EUR`.
    temp2-initial = `G`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    temp2-description = `7" LCD Screen, storage battery holds up to 6 hours!`.
    temp2-price = `249.99`.
    temp2-currencycode = `EUR`.
    temp2-initial = `7`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `10" Portable DVD player`.
    temp2-description = `10" LCD Screen, storage battery holds up to 8 hours`.
    temp2-price = `449.99`.
    temp2-currencycode = `EUR`.
    temp2-initial = `1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    temp2-description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included`.
    temp2-price = `853.99`.
    temp2-currencycode = `EUR`.
    temp2-initial = `P`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `CD/DVD case: 264 sleeves`.
    temp2-description = `Organizer and protective case for 264 CDs and DVDs`.
    temp2-price = `44.99`.
    temp2-currencycode = `EUR`.
    temp2-initial = `C`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    temp2-description = `Quality cables for notebooks and projectors`.
    temp2-price = `29.99`.
    temp2-currencycode = `EUR`.
    temp2-initial = `A`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Removable CD/DVD Laser Labels`.
    temp2-description = `Removable jewel case labels, zero residues (100)`.
    temp2-price = `8.99`.
    temp2-currencycode = `EUR`.
    temp2-initial = `R`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-1`.
    temp2-description = `720p, DLP Projector max. 8,45 Meter, 2D`.
    temp2-price = `469`.
    temp2-currencycode = `EUR`.
    temp2-initial = `B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-2`.
    temp2-description = `1080p, DLP max.9,34 Meter, 2D-ready`.
    temp2-price = `679`.
    temp2-currencycode = `EUR`.
    temp2-initial = `B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Beam Breaker B-3`.
    temp2-description = `1080p, DLP max. 12,3 Meter, 3D-ready`.
    temp2-price = `889`.
    temp2-currencycode = `EUR`.
    temp2-initial = `B`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Play Movie`.
    temp2-description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp2-price = `130`.
    temp2-currencycode = `EUR`.
    temp2-initial = `P`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Record Movie`.
    temp2-description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp2-price = `288`.
    temp2-currencycode = `EUR`.
    temp2-initial = `R`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo MusicStick`.
    temp2-description = `64 GB USB Music-on-Available-Stick`.
    temp2-price = `45`.
    temp2-currencycode = `EUR`.
    temp2-initial = `I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelo Jog-Mate`.
    temp2-description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`.
    temp2-price = `63`.
    temp2-currencycode = `EUR`.
    temp2-initial = `I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 40`.
    temp2-description = `MP3-Player with 40 GB HDD and Color Display, can play movies`.
    temp2-price = `167`.
    temp2-currencycode = `EUR`.
    temp2-initial = `P`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Power Pro Player 80`.
    temp2-description = `MP3-Player with 80 GB SSD and Color Display, can play movies`.
    temp2-price = `299`.
    temp2-currencycode = `EUR`.
    temp2-initial = `P`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD32`.
    temp2-description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp2-price = `1459`.
    temp2-currencycode = `EUR`.
    temp2-initial = `F`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD37`.
    temp2-description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp2-price = `1199`.
    temp2-currencycode = `EUR`.
    temp2-initial = `F`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Watch HD41`.
    temp2-description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp2-price = `899`.
    temp2-currencycode = `EUR`.
    temp2-initial = `F`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Copperberry`.
    temp2-description = `Our new multifunctional Handheld with phone function in copper`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    temp2-initial = `C`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Silverberry`.
    temp2-description = `Our new multifunctional Handheld with phone function in silver`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Goldberry`.
    temp2-description = `Our new multifunctional Handheld with phone function in gold`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    temp2-initial = `G`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Platinberry`.
    temp2-description = `Our new multifunctional Handheld with phone function in platinum`.
    temp2-price = `549`.
    temp2-currencycode = `EUR`.
    temp2-initial = `P`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I4000`.
    temp2-description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp2-price = `799`.
    temp2-currencycode = `EUR`.
    temp2-initial = `I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I6300c`.
    temp2-description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp2-price = `799`.
    temp2-currencycode = `EUR`.
    temp2-initial = `I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9100`.
    temp2-description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp2-price = `1199`.
    temp2-currencycode = `EUR`.
    temp2-initial = `I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO FlexTop I9800`.
    temp2-description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp2-price = `1388`.
    temp2-currencycode = `EUR`.
    temp2-initial = `I`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Leather Case`.
    temp2-description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models`.
    temp2-price = `25`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Alpha`.
    temp2-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp2-price = `599`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Mini Tablet`.
    temp2-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`.
    temp2-price = `833`.
    temp2-currencycode = `EUR`.
    temp2-initial = `M`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Camcorder View`.
    temp2-description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`.
    temp2-price = `1388`.
    temp2-currencycode = `EUR`.
    temp2-initial = `C`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    temp2-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp2-price = `20`.
    temp2-currencycode = `EUR`.
    temp2-initial = `T`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tablet Pouch`.
    temp2-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp2-price = `20`.
    temp2-currencycode = `EUR`.
    temp2-initial = `T`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `e-Book Reader ReadMe`.
    temp2-description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`.
    temp2-price = `33`.
    temp2-currencycode = `EUR`.
    temp2-initial = `e`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Smartphone Beta`.
    temp2-description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support`.
    temp2-price = `30`.
    temp2-currencycode = `EUR`.
    temp2-initial = `S`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Maxi Tablet`.
    temp2-description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp2-price = `749`.
    temp2-currencycode = `EUR`.
    temp2-initial = `M`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flyer`.
    temp2-description = `Flyer for our product palette`.
    temp2-price = `0`.
    temp2-currencycode = `EUR`.
    temp2-initial = `F`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.

ENDCLASS.
