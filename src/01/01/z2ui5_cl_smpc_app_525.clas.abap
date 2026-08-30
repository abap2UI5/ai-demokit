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
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

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
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

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
    t_products = VALUE #(
        ( name = `Notebook Basic 15`        description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`                                             price = `956`  currencycode = `EUR` initial = `N` )
        ( name = `Notebook Basic 17`        description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`                                             price = `1249` currencycode = `EUR` initial = `N` )
        ( name = `Notebook Basic 18`        description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`                                            price = `1570` currencycode = `EUR` initial = `N` )
        ( name = `Notebook Basic 19`        description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`                                            price = `1650` currencycode = `EUR` initial = `N` )
        ( name = `ITelO Vault`              description = `Digital Organizer with State-of-the-Art Storage Encryption`                                                                                     price = `299`  currencycode = `EUR` initial = `I` )
        ( name = `Notebook Professional 15` description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` price = `1999` currencycode = `EUR` initial = `N` )
        ( name = `Notebook Professional 17` description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` price = `2299` currencycode = `EUR` initial = `N` )
        ( name = `ITelO Vault Net`          description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`                                                      price = `459`  currencycode = `EUR` initial = `I` )
        ( name = `ITelO Vault SAT`          description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`                                                        price = `149`  currencycode = `EUR` initial = `I` )
        ( name = `Comfort Easy`             description = `32 GB Digital Assistant with high-resolution color screen`                                                                                      price = `1679` currencycode = `EUR` initial = `C` )
        ( name = `Comfort Senior`           description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output`                                                         price = `512`  currencycode = `EUR` initial = `C` )
        ( name = `Ergo Screen E-I`          description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`                                                                               price = `230`  currencycode = `EUR` initial = `E` )
        ( name = `Ergo Screen E-II`         description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`                                                                               price = `285`  currencycode = `EUR` initial = `E` )
        ( name = `Ergo Screen E-III`        description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`                                                                               price = `345`  currencycode = `EUR` initial = `E` )
        ( name = `Flat Basic`               description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`                                                                               price = `399`  currencycode = `EUR` initial = `F` )
        ( name = `Flat Future`              description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`                                                                               price = `430`  currencycode = `EUR` initial = `F` )
        ( name = `Flat XL`                  description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`                                                                               price = `1230` currencycode = `EUR` initial = `F` )
        ( name = `Laser Professional Eco` description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`
          price = `830` currencycode = `EUR` initial = `L` )
        ( name = `Laser Basic` description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory` price = `490` currencycode = `EUR` initial = `L` )
        ( name = `Laser Allround` description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`
          price = `349` currencycode = `EUR` initial = `L` )
        ( name = `Ultra Jet Super Color` description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet` price = `139` currencycode = `EUR` initial = `U` )
        ( name = `Ultra Jet Mobile` description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office` price = `99` currencycode = `EUR` initial = `U` )
        ( name = `Ultra Jet Super Highspeed` description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet` price = `170` currencycode = `EUR` initial = `U` )
        ( name = `Multi Print` description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)` price = `99` currencycode = `EUR` initial = `M` )
        ( name = `Multi Color` description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)` price = `119` currencycode = `EUR` initial = `M` )
        ( name = `Cordless Mouse` description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play` price = `9` currencycode = `EUR` initial = `C` )
        ( name = `Speed Mouse` description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)` price = `7` currencycode = `EUR` initial = `S` )
        ( name = `Track Mouse` description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play` price = `11` currencycode = `EUR` initial = `T` )
        ( name = `Ergonomic Keyboard` description = `Ergonomic USB Keyboard for Desktop, Plug&Play` price = `14` currencycode = `EUR` initial = `E` )
        ( name = `Internet Keyboard` description = `Corded Keyboard with special keys for Internet Usability, USB` price = `16` currencycode = `EUR` initial = `I` )
        ( name = `Media Keyboard` description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB` price = `26` currencycode = `EUR` initial = `M` )
        ( name = `Mousepad` description = `Nice mouse pad with ITelO Logo` price = `6.99` currencycode = `EUR` initial = `M` )
        ( name = `Ergo Mousepad` description = `Ergonomic mouse pad with ITelO Logo` price = `8.99` currencycode = `EUR` initial = `E` )
        ( name = `Designer Mousepad` description = `ITelO Mousepad Special Edition` price = `12.99` currencycode = `EUR` initial = `D` )
        ( name = `Universal card reader` description = `Universal card reader` price = `14` currencycode = `EUR` initial = `U` )
        ( name = `Proctra X` description = `Proctra X: PCI-E GDDR5 3072MB` price = `70.9` currencycode = `EUR` initial = `P` )
        ( name = `Gladiator MX` description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise` price = `81.7` currencycode = `EUR` initial = `G` )
        ( name = `Hurricane GX` description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized` price = `101.2` currencycode = `EUR` initial = `H` )
        ( name = `Hurricane GX/LN` description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.` price = `139.99` currencycode = `EUR` initial = `H` )
        ( name = `Photo Scan` description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth` price = `129` currencycode = `EUR` initial = `P` )
        ( name = `Power Scan` description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility` price = `89` currencycode = `EUR` initial = `P` )
        ( name = `Jet Scan Professional` description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` price = `169` currencycode = `EUR` initial = `J` )
        ( name = `Jet Scan Professional` description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` price = `189` currencycode = `EUR` initial = `J` )
        ( name = `Copymaster` description = `Copymaster` price = `1499` currencycode = `EUR` initial = `C` )
        ( name = `Surround Sound` description = `PC multimedia speakers - 5 Watt (Total)` price = `39` currencycode = `EUR` initial = `S` )
        ( name = `Blaster Extreme` description = `PC multimedia speakers - 10 Watt (Total) - 2-way` price = `26` currencycode = `EUR` initial = `B` )
        ( name = `Sound Booster` description = `PC multimedia speakers - optimized for Blutooth/A2DP` price = `45` currencycode = `EUR` initial = `S` )
        ( name = `Lovely Sound 5.1 Wireless` description = `5.1 Headset, 40 Hz-20 kHz, Wireless` price = `49` currencycode = `EUR` initial = `L` )
        ( name = `Lovely Sound 5.1` description = `5.1 Headset, 40 Hz-20 kHz, 3m cable` price = `39` currencycode = `EUR` initial = `L` )
        ( name = `Lovely Sound Stereo` description = `5.1 Headset, 40 Hz-20 kHz, 1m cable` price = `29` currencycode = `EUR` initial = `L` )
        ( name = `Smart Office` description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)` price = `89.9` currencycode = `EUR` initial = `S` )
        ( name = `Smart Design` description = `Complete package, 1 User, Image editing, processing` price = `79.9` currencycode = `EUR` initial = `S` )
        ( name = `Smart Network` description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation` price = `69` currencycode = `EUR` initial = `S` )
        ( name = `Smart Multimedia` description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package` price = `77` currencycode = `EUR` initial = `S` )
        ( name = `Smart Games` description = `Complete package, 1 User, various games for amusement, logic, action, jump&run` price = `55` currencycode = `EUR` initial = `S` )
        ( name = `Smart Internet Antivirus` description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection` price = `29` currencycode = `EUR` initial = `S` )
        ( name = `Smart Firewall` description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime` price = `34` currencycode = `EUR` initial = `S` )
        ( name = `Smart Money` description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want` price = `29.9` currencycode = `EUR` initial = `S` )
        ( name = `PC Lock` description = `Robust 3m anti-burglary protection for your laptop computer` price = `8.9` currencycode = `EUR` initial = `P` )
        ( name = `Notebook Lock` description = `Robust 1m anti-burglary protection for your desktop computer` price = `6.9` currencycode = `EUR` initial = `N` )
        ( name = `Web cam reality` description = `Color webcam, color, High-Speed USB` price = `39` currencycode = `EUR` initial = `W` )
        ( name = `Screen clean` description = `10 separately packed screen wipes` price = `2.3` currencycode = `EUR` initial = `S` )
        ( name = `Fabric bag professional` description = `Notebook bag, plenty of room for stationery and writing materials` price = `31` currencycode = `EUR` initial = `F` )
        ( name = `Wireless DSL Router` description = `Wireless DSL Router (available in blue, black and silver)` price = `49` currencycode = `EUR` initial = `W` )
        ( name = `Wireless DSL Router / Repeater` description = `Wireless DSL Router / Repeater (available in blue, black and silver)` price = `59` currencycode = `EUR` initial = `W` )
        ( name = `Wireless DSL Router / Repeater and Print Server` description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)` price = `69` currencycode = `EUR` initial = `W` )
        ( name = `USB Stick` description = `USB 2.0 High-Speed 64 GB` price = `35` currencycode = `EUR` initial = `U` )
        ( name = `Travel Adapter` description = `Universal Travel Adapter` price = `79` currencycode = `EUR` initial = `T` )
        ( name = `Cordless Bluetooth Keyboard, english international` description = `Cordless Bluetooth Keyboard with English keys` price = `29` currencycode = `EUR` initial = `C` )
        ( name = `Flat XXL` description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm` price = `1430` currencycode = `EUR` initial = `F` )
        ( name = `Pocket Mouse` description = `Portable pocket Mouse with retracting cord` price = `23` currencycode = `EUR` initial = `P` )
        ( name = `PC Power Station` description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro` price = `2399` currencycode = `EUR` initial = `P` )
        ( name = `Astro Laptop 1516` description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro` price = `989` currencycode = `EUR` initial = `A` )
        ( name = `Astro Phone 6` description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black`
          price = `649` currencycode = `EUR` initial = `A` )
        ( name = `Benda Laptop 1408`   description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro`      price = `976` currencycode = `EUR` initial = `B` )
        ( name = `Bending Screen 21HD` description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` price = `250` currencycode = `EUR` initial = `B` )
        ( name = `Broad Screen 22HD`   description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` price = `270` currencycode = `EUR` initial = `B` )
        ( name = `Cerdik Phone 7` description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`
          price = `549` currencycode = `EUR` initial = `C` )
        ( name = `Cepat Tablet 10.5` description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` price = `549` currencycode = `EUR` initial = `C` )
        ( name = `Cepat Tablet 8` description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor` price = `529` currencycode = `EUR` initial = `C` )
        ( name = `Server Basic` description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity` price = `5000` currencycode = `EUR` initial = `S` )
        ( name = `Server Professional` description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity` price = `15000` currencycode = `EUR` initial = `S` )
        ( name = `Server Power Pro` description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity` price = `25000` currencycode = `EUR` initial = `S` )
        ( name = `Family PC Basic` description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8` price = `600` currencycode = `EUR` initial = `F` )
        ( name = `Family PC Pro` description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` price = `900` currencycode = `EUR` initial = `F` )
        ( name = `Gaming Monster` description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` price = `1200` currencycode = `EUR` initial = `G` )
        ( name = `Gaming Monster Pro` description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8` price = `1700` currencycode = `EUR` initial = `G` )
        ( name = `7" Widescreen Portable DVD Player w MP3` description = `7" LCD Screen, storage battery holds up to 6 hours!` price = `249.99` currencycode = `EUR` initial = `7` )
        ( name = `10" Portable DVD player` description = `10" LCD Screen, storage battery holds up to 8 hours` price = `449.99` currencycode = `EUR` initial = `1` )
        ( name = `Portable DVD Player with 9" LCD Monitor` description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included` price = `853.99` currencycode = `EUR` initial = `P` )
        ( name = `CD/DVD case: 264 sleeves` description = `Organizer and protective case for 264 CDs and DVDs` price = `44.99` currencycode = `EUR` initial = `C` )
        ( name = `Audio/Video Cable Kit - 4m` description = `Quality cables for notebooks and projectors` price = `29.99` currencycode = `EUR` initial = `A` )
        ( name = `Removable CD/DVD Laser Labels` description = `Removable jewel case labels, zero residues (100)` price = `8.99` currencycode = `EUR` initial = `R` )
        ( name = `Beam Breaker B-1` description = `720p, DLP Projector max. 8,45 Meter, 2D` price = `469` currencycode = `EUR` initial = `B` )
        ( name = `Beam Breaker B-2` description = `1080p, DLP max.9,34 Meter, 2D-ready` price = `679` currencycode = `EUR` initial = `B` )
        ( name = `Beam Breaker B-3` description = `1080p, DLP max. 12,3 Meter, 3D-ready` price = `889` currencycode = `EUR` initial = `B` )
        ( name = `Play Movie` description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` price = `130` currencycode = `EUR` initial = `P` )
        ( name = `Record Movie` description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` price = `288` currencycode = `EUR` initial = `R` )
        ( name = `ITelo MusicStick` description = `64 GB USB Music-on-Available-Stick` price = `45` currencycode = `EUR` initial = `I` )
        ( name = `ITelo Jog-Mate` description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies` price = `63` currencycode = `EUR` initial = `I` )
        ( name = `Power Pro Player 40` description = `MP3-Player with 40 GB HDD and Color Display, can play movies` price = `167` currencycode = `EUR` initial = `P` )
        ( name = `Power Pro Player 80` description = `MP3-Player with 80 GB SSD and Color Display, can play movies` price = `299` currencycode = `EUR` initial = `P` )
        ( name = `Flat Watch HD32` description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready` price = `1459` currencycode = `EUR` initial = `F` )
        ( name = `Flat Watch HD37` description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready` price = `1199` currencycode = `EUR` initial = `F` )
        ( name = `Flat Watch HD41` description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready` price = `899` currencycode = `EUR` initial = `F` )
        ( name = `Copperberry` description = `Our new multifunctional Handheld with phone function in copper` price = `549` currencycode = `EUR` initial = `C` )
        ( name = `Silverberry` description = `Our new multifunctional Handheld with phone function in silver` price = `549` currencycode = `EUR` initial = `S` )
        ( name = `Goldberry` description = `Our new multifunctional Handheld with phone function in gold` price = `549` currencycode = `EUR` initial = `G` )
        ( name = `Platinberry` description = `Our new multifunctional Handheld with phone function in platinum` price = `549` currencycode = `EUR` initial = `P` )
        ( name = `ITelO FlexTop I4000` description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` price = `799` currencycode = `EUR` initial = `I` )
        ( name = `ITelO FlexTop I6300c` description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` price = `799` currencycode = `EUR` initial = `I` )
        ( name = `ITelO FlexTop I9100` description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` price = `1199` currencycode = `EUR` initial = `I` )
        ( name = `ITelO FlexTop I9800` description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` price = `1388` currencycode = `EUR` initial = `I` )
        ( name = `Smartphone Leather Case` description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models` price = `25` currencycode = `EUR` initial = `S` )
        ( name = `Smartphone Alpha` description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`
          price = `599` currencycode = `EUR` initial = `S` )
        ( name = `Mini Tablet`          description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`     price = `833`  currencycode = `EUR` initial = `M` )
        ( name = `Camcorder View`       description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`          price = `1388` currencycode = `EUR` initial = `C` )
        ( name = `Tablet Pouch`         description = `Stylish tablet pouch, protects from scratches, color: black`                                                                           price = `20`   currencycode = `EUR` initial = `T` )
        ( name = `Tablet Pouch`         description = `Stylish tablet pouch, protects from scratches, color: black`                                                                           price = `20`   currencycode = `EUR` initial = `T` )
        ( name = `e-Book Reader ReadMe` description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`                               price = `33`   currencycode = `EUR` initial = `e` )
        ( name = `Smartphone Beta`      description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support`                                                          price = `30`   currencycode = `EUR` initial = `S` )
        ( name = `Maxi Tablet`          description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` price = `749`  currencycode = `EUR` initial = `M` )
        ( name = `Flyer`                description = `Flyer for our product palette`                                                                                                         price = `0`    currencycode = `EUR` initial = `F` ) ).

  ENDMETHOD.

ENDCLASS.
