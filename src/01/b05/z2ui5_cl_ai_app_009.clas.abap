CLASS z2ui5_cl_ai_app_009 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id     TYPE string,
        name           TYPE string,
        supplier_name  TYPE string,
        weight_measure TYPE p LENGTH 8 DECIMALS 3,
        weight_unit    TYPE string,
        price          TYPE p LENGTH 8 DECIMALS 2,
        currency_code  TYPE string,
        width          TYPE p LENGTH 4 DECIMALS 1,
        depth          TYPE p LENGTH 4 DECIMALS 1,
        height         TYPE p LENGTH 4 DECIMALS 1,
        dim_unit       TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA t_sticky TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    DATA popin_key TYPE string.
    DATA toggle_pressed TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_009 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the shared mock /ProductCollection flattened to the bound columns, all 123 rows kept verbatim (see the IMPROVISED deviation)
    t_products = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15` supplier_name = `Very Best Screens`
        weight_measure = '4.2' weight_unit = `KG` price = '956' currency_code = `EUR` width = '30' depth = '18' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1001` name = `Notebook Basic 17` supplier_name = `Very Best Screens`
        weight_measure = '4.5' weight_unit = `KG` price = '1249' currency_code = `EUR` width = '29' depth = '17' height = '3.1' dim_unit = `cm` )
      ( product_id = `HT-1002` name = `Notebook Basic 18` supplier_name = `Very Best Screens`
        weight_measure = '4.2' weight_unit = `KG` price = '1570' currency_code = `EUR` width = '28' depth = '19' height = '2.5' dim_unit = `cm` )
      ( product_id = `HT-1003` name = `Notebook Basic 19` supplier_name = `Smartcards`
        weight_measure = '4.2' weight_unit = `KG` price = '1650' currency_code = `EUR` width = '32' depth = '21' height = '4' dim_unit = `cm` )
      ( product_id = `HT-1007` name = `ITelO Vault` supplier_name = `Technocom`
        weight_measure = '0.2' weight_unit = `KG` price = '299' currency_code = `EUR` width = '32' depth = '22' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1010` name = `Notebook Professional 15` supplier_name = `Very Best Screens`
        weight_measure = '4.3' weight_unit = `KG` price = '1999' currency_code = `EUR` width = '33' depth = '20' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1011` name = `Notebook Professional 17` supplier_name = `Very Best Screens`
        weight_measure = '4.1' weight_unit = `KG` price = '2299' currency_code = `EUR` width = '33' depth = '23' height = '2' dim_unit = `cm` )
      ( product_id = `HT-1020` name = `ITelO Vault Net` supplier_name = `Technocom`
        weight_measure = '0.16' weight_unit = `KG` price = '459' currency_code = `EUR` width = '10' depth = '1.8' height = '17' dim_unit = `cm` )
      ( product_id = `HT-1021` name = `ITelO Vault SAT` supplier_name = `Technocom`
        weight_measure = '0.18' weight_unit = `KG` price = '149' currency_code = `EUR` width = '11' depth = '1.7' height = '18' dim_unit = `cm` )
      ( product_id = `HT-1022` name = `Comfort Easy` supplier_name = `Technocom`
        weight_measure = '0.2' weight_unit = `KG` price = '1679' currency_code = `EUR` width = '84' depth = '1.5' height = '14' dim_unit = `cm` )
      ( product_id = `HT-1023` name = `Comfort Senior` supplier_name = `Technocom`
        weight_measure = '0.8' weight_unit = `KG` price = '512' currency_code = `EUR` width = '80' depth = '1.6' height = '13' dim_unit = `cm` )
      ( product_id = `HT-1030` name = `Ergo Screen E-I` supplier_name = `Very Best Screens`
        weight_measure = '21' weight_unit = `KG` price = '230' currency_code = `EUR` width = '37' depth = '12' height = '36' dim_unit = `cm` )
      ( product_id = `HT-1031` name = `Ergo Screen E-II` supplier_name = `Very Best Screens`
        weight_measure = '21' weight_unit = `KG` price = '285' currency_code = `EUR` width = '40.8' depth = '19' height = '43' dim_unit = `cm` )
      ( product_id = `HT-1032` name = `Ergo Screen E-III` supplier_name = `Very Best Screens`
        weight_measure = '21' weight_unit = `KG` price = '345' currency_code = `EUR` width = '40.8' depth = '19' height = '43' dim_unit = `cm` )
      ( product_id = `HT-1035` name = `Flat Basic` supplier_name = `Very Best Screens`
        weight_measure = '14' weight_unit = `KG` price = '399' currency_code = `EUR` width = '39' depth = '20' height = '41' dim_unit = `cm` )
      ( product_id = `HT-1036` name = `Flat Future` supplier_name = `Very Best Screens`
        weight_measure = '15' weight_unit = `KG` price = '430' currency_code = `EUR` width = '45' depth = '26' height = '46' dim_unit = `cm` )
      ( product_id = `HT-1037` name = `Flat XL` supplier_name = `Very Best Screens`
        weight_measure = '17' weight_unit = `KG` price = '1230' currency_code = `EUR` width = '54.5' depth = '22.1' height = '39.1' dim_unit = `cm` )
      ( product_id = `HT-1040` name = `Laser Professional Eco` supplier_name = `Alpha Printers`
        weight_measure = '32' weight_unit = `KG` price = '830' currency_code = `EUR` width = '51' depth = '46' height = '30' dim_unit = `cm` )
      ( product_id = `HT-1041` name = `Laser Basic` supplier_name = `Alpha Printers`
        weight_measure = '23' weight_unit = `KG` price = '490' currency_code = `EUR` width = '48' depth = '42' height = '26' dim_unit = `cm` )
      ( product_id = `HT-1042` name = `Laser Allround` supplier_name = `Alpha Printers`
        weight_measure = '17' weight_unit = `KG` price = '349' currency_code = `EUR` width = '53' depth = '50' height = '65' dim_unit = `cm` )
      ( product_id = `HT-1050` name = `Ultra Jet Super Color` supplier_name = `Alpha Printers`
        weight_measure = '3' weight_unit = `KG` price = '139' currency_code = `EUR` width = '41' depth = '41' height = '28' dim_unit = `cm` )
      ( product_id = `HT-1051` name = `Ultra Jet Mobile` supplier_name = `Printer for All`
        weight_measure = '1.9' weight_unit = `KG` price = '99' currency_code = `EUR` width = '46' depth = '32' height = '25' dim_unit = `cm` )
      ( product_id = `HT-1052` name = `Ultra Jet Super Highspeed` supplier_name = `Printer for All`
        weight_measure = '18' weight_unit = `KG` price = '170' currency_code = `EUR` width = '41' depth = '41' height = '28' dim_unit = `cm` )
      ( product_id = `HT-1055` name = `Multi Print` supplier_name = `Printer for All`
        weight_measure = '6.3' weight_unit = `KG` price = '99' currency_code = `EUR` width = '55' depth = '45' height = '29' dim_unit = `cm` )
      ( product_id = `HT-1056` name = `Multi Color` supplier_name = `Printer for All`
        weight_measure = '4.3' weight_unit = `KG` price = '119' currency_code = `EUR` width = '51' depth = '41.3' height = '22' dim_unit = `cm` )
      ( product_id = `HT-1060` name = `Cordless Mouse` supplier_name = `Oxynum`
        weight_measure = '0.09' weight_unit = `KG` price = '9' currency_code = `EUR` width = '6' depth = '14.5' height = '3.5' dim_unit = `cm` )
      ( product_id = `HT-1061` name = `Speed Mouse` supplier_name = `Oxynum`
        weight_measure = '0.09' weight_unit = `KG` price = '7' currency_code = `EUR` width = '7' depth = '15' height = '3.1' dim_unit = `cm` )
      ( product_id = `HT-1062` name = `Track Mouse` supplier_name = `Oxynum`
        weight_measure = '0.03' weight_unit = `KG` price = '11' currency_code = `EUR` width = '3' depth = '7' height = '4' dim_unit = `cm` )
      ( product_id = `HT-1063` name = `Ergonomic Keyboard` supplier_name = `Oxynum`
        weight_measure = '2.1' weight_unit = `KG` price = '14' currency_code = `EUR` width = '50' depth = '21' height = '3.5' dim_unit = `cm` )
      ( product_id = `HT-1064` name = `Internet Keyboard` supplier_name = `Oxynum`
        weight_measure = '1.8' weight_unit = `KG` price = '16' currency_code = `EUR` width = '52' depth = '25' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1065` name = `Media Keyboard` supplier_name = `Oxynum`
        weight_measure = '2.3' weight_unit = `KG` price = '26' currency_code = `EUR` width = '51.4' depth = '23' height = '4' dim_unit = `cm` )
      ( product_id = `HT-1066` name = `Mousepad` supplier_name = `Oxynum`
        weight_measure = '80' weight_unit = `G` price = '6.99' currency_code = `EUR` width = '15' depth = '6' height = '0.2' dim_unit = `cm` )
      ( product_id = `HT-1067` name = `Ergo Mousepad` supplier_name = `Oxynum`
        weight_measure = '80' weight_unit = `G` price = '8.99' currency_code = `EUR` width = '15' depth = '6' height = '0.2' dim_unit = `cm` )
      ( product_id = `HT-1068` name = `Designer Mousepad` supplier_name = `Fasttech`
        weight_measure = '90' weight_unit = `G` price = '12.99' currency_code = `EUR` width = '24' depth = '24' height = '0.6' dim_unit = `cm` )
      ( product_id = `HT-1069` name = `Universal card reader` supplier_name = `Fasttech`
        weight_measure = '45' weight_unit = `G` price = '14' currency_code = `EUR` width = '6' depth = '6' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1070` name = `Proctra X` supplier_name = `Ultrasonic United`
        weight_measure = '0.255' weight_unit = `KG` price = '70.9' currency_code = `EUR` width = '22' depth = '35' height = '17' dim_unit = `cm` )
      ( product_id = `HT-1071` name = `Gladiator MX` supplier_name = `Ultrasonic United`
        weight_measure = '0.3' weight_unit = `KG` price = '81.7' currency_code = `EUR` width = '22' depth = '35' height = '17' dim_unit = `cm` )
      ( product_id = `HT-1072` name = `Hurricane GX` supplier_name = `Ultrasonic United`
        weight_measure = '0.4' weight_unit = `KG` price = '101.2' currency_code = `EUR` width = '22' depth = '35' height = '17' dim_unit = `cm` )
      ( product_id = `HT-1073` name = `Hurricane GX/LN` supplier_name = `Smartcards`
        weight_measure = '0.4' weight_unit = `KG` price = '139.99' currency_code = `EUR` width = '22' depth = '35' height = '17' dim_unit = `cm` )
      ( product_id = `HT-1080` name = `Photo Scan` supplier_name = `Printer for All`
        weight_measure = '2.3' weight_unit = `KG` price = '129' currency_code = `EUR` width = '34' depth = '48' height = '5' dim_unit = `cm` )
      ( product_id = `HT-1081` name = `Power Scan` supplier_name = `Printer for All`
        weight_measure = '2.4' weight_unit = `KG` price = '89' currency_code = `EUR` width = '31' depth = '43' height = '7' dim_unit = `cm` )
      ( product_id = `HT-1082` name = `Jet Scan Professional` supplier_name = `Printer for All`
        weight_measure = '3.2' weight_unit = `KG` price = '169' currency_code = `EUR` width = '33' depth = '41' height = '12' dim_unit = `cm` )
      ( product_id = `HT-1083` name = `Jet Scan Professional` supplier_name = `Printer for All`
        weight_measure = '3.2' weight_unit = `KG` price = '189' currency_code = `EUR` width = '35' depth = '40' height = '10' dim_unit = `cm` )
      ( product_id = `HT-1085` name = `Copymaster` supplier_name = `Alpha Printers`
        weight_measure = '23.2' weight_unit = `KG` price = '1499' currency_code = `EUR` width = '45' depth = '42' height = '22' dim_unit = `cm` )
      ( product_id = `HT-1090` name = `Surround Sound` supplier_name = `Speaker Experts`
        weight_measure = '3' weight_unit = `KG` price = '39' currency_code = `EUR` width = '12' depth = '10' height = '16' dim_unit = `cm` )
      ( product_id = `HT-1091` name = `Blaster Extreme` supplier_name = `Speaker Experts`
        weight_measure = '1.4' weight_unit = `KG` price = '26' currency_code = `EUR` width = '13' depth = '11' height = '17.5' dim_unit = `cm` )
      ( product_id = `HT-1092` name = `Sound Booster` supplier_name = `Speaker Experts`
        weight_measure = '2.1' weight_unit = `KG` price = '45' currency_code = `EUR` width = '12.4' depth = '10.4' height = '18.1' dim_unit = `cm` )
      ( product_id = `HT-1095` name = `Lovely Sound 5.1 Wireless` supplier_name = `Fasttech`
        weight_measure = '80' weight_unit = `G` price = '49' currency_code = `EUR` width = '24' depth = '19' height = '23' dim_unit = `cm` )
      ( product_id = `HT-1096` name = `Lovely Sound 5.1` supplier_name = `Fasttech`
        weight_measure = '130' weight_unit = `G` price = '39' currency_code = `EUR` width = '25' depth = '17' height = '19' dim_unit = `cm` )
      ( product_id = `HT-1097` name = `Lovely Sound Stereo` supplier_name = `Fasttech`
        weight_measure = '60' weight_unit = `G` price = '29' currency_code = `EUR` width = '21.3' depth = '2.4' height = '19.7' dim_unit = `cm` )
      ( product_id = `HT-1100` name = `Smart Office` supplier_name = `Technocom`
        weight_measure = '1.2' weight_unit = `KG` price = '89.9' currency_code = `EUR` width = '15' depth = '6.5' height = '2.1' dim_unit = `cm` )
      ( product_id = `HT-1101` name = `Smart Design` supplier_name = `Technocom`
        weight_measure = '0.8' weight_unit = `KG` price = '79.9' currency_code = `EUR` width = '14' depth = '6.7' height = '24' dim_unit = `cm` )
      ( product_id = `HT-1102` name = `Smart Network` supplier_name = `Technocom`
        weight_measure = '0.8' weight_unit = `KG` price = '69' currency_code = `EUR` width = '16' depth = '6' height = '27' dim_unit = `cm` )
      ( product_id = `HT-1103` name = `Smart Multimedia` supplier_name = `Technocom`
        weight_measure = '0.8' weight_unit = `KG` price = '77' currency_code = `EUR` width = '11' depth = '3.4' height = '22' dim_unit = `cm` )
      ( product_id = `HT-1104` name = `Smart Games` supplier_name = `Technocom`
        weight_measure = '1.1' weight_unit = `KG` price = '55' currency_code = `EUR` width = '10' depth = '3' height = '30' dim_unit = `cm` )
      ( product_id = `HT-1105` name = `Smart Internet Antivirus` supplier_name = `Brainsoft`
        weight_measure = '0.7' weight_unit = `KG` price = '29' currency_code = `EUR` width = '16' depth = '4' height = '21' dim_unit = `cm` )
      ( product_id = `HT-1106` name = `Smart Firewall` supplier_name = `Brainsoft`
        weight_measure = '0.9' weight_unit = `KG` price = '34' currency_code = `EUR` width = '17.9' depth = '4.2' height = '23.1' dim_unit = `cm` )
      ( product_id = `HT-1107` name = `Smart Money` supplier_name = `Brainsoft`
        weight_measure = '0.5' weight_unit = `KG` price = '29.9' currency_code = `EUR` width = '12' depth = '1.5' height = '19' dim_unit = `cm` )
      ( product_id = `HT-1110` name = `PC Lock` supplier_name = `Red Point Stores`
        weight_measure = '0.03' weight_unit = `KG` price = '8.9' currency_code = `EUR` width = '20' depth = '8' height = '4.3' dim_unit = `cm` )
      ( product_id = `HT-1111` name = `Notebook Lock` supplier_name = `Red Point Stores`
        weight_measure = '0.02' weight_unit = `KG` price = '6.9' currency_code = `EUR` width = '31' depth = '9' height = '7' dim_unit = `cm` )
      ( product_id = `HT-1112` name = `Web cam reality` supplier_name = `Red Point Stores`
        weight_measure = '0.075' weight_unit = `KG` price = '39' currency_code = `EUR` width = '9' depth = '8.2' height = '1.3' dim_unit = `cm` )
      ( product_id = `HT-1113` name = `Screen clean` supplier_name = `Red Point Stores`
        weight_measure = '0.05' weight_unit = `KG` price = '2.3' currency_code = `EUR` width = '2' depth = '2' height = '0.1' dim_unit = `cm` )
      ( product_id = `HT-1114` name = `Fabric bag professional` supplier_name = `Red Point Stores`
        weight_measure = '1.8' weight_unit = `KG` price = '31' currency_code = `EUR` width = '42' depth = '32' height = '7' dim_unit = `cm` )
      ( product_id = `HT-1115` name = `Wireless DSL Router` supplier_name = `Red Point Stores`
        weight_measure = '0.45' weight_unit = `KG` price = '49' currency_code = `EUR` width = '19.3' depth = '18' height = '5' dim_unit = `cm` )
      ( product_id = `HT-1116` name = `Wireless DSL Router / Repeater` supplier_name = `Red Point Stores`
        weight_measure = '0.45' weight_unit = `KG` price = '59' currency_code = `EUR` width = '19.3' depth = '18' height = '5' dim_unit = `cm` )
      ( product_id = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server` supplier_name = `Technocom`
        weight_measure = '0.45' weight_unit = `KG` price = '69' currency_code = `EUR` width = '19.3' depth = '18' height = '5' dim_unit = `cm` )
      ( product_id = `HT-1118` name = `USB Stick` supplier_name = `Technocom`
        weight_measure = '0.015' weight_unit = `KG` price = '35' currency_code = `EUR` width = '1.5' depth = '8.7' height = '1.2' dim_unit = `cm` )
      ( product_id = `HT-1119` name = `Travel Adapter` supplier_name = `Titanium`
        weight_measure = '88' weight_unit = `G` price = '79' currency_code = `EUR` width = '2' depth = '3.1' height = '3.9' dim_unit = `cm` )
      ( product_id = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` supplier_name = `Technocom`
        weight_measure = '1' weight_unit = `KG` price = '29' currency_code = `EUR` width = '51.4' depth = '23' height = '4' dim_unit = `cm` )
      ( product_id = `HT-1137` name = `Flat XXL` supplier_name = `Technocom`
        weight_measure = '18' weight_unit = `KG` price = '1430' currency_code = `EUR` width = '54' depth = '22' height = '38' dim_unit = `cm` )
      ( product_id = `HT-1138` name = `Pocket Mouse` supplier_name = `Technocom`
        weight_measure = '0.02' weight_unit = `KG` price = '23' currency_code = `EUR` width = '0.3' depth = '0.5' height = '1' dim_unit = `cm` )
      ( product_id = `HT-1210` name = `PC Power Station` supplier_name = `Technocom`
        weight_measure = '2.3' weight_unit = `KG` price = '2399' currency_code = `EUR` width = '28' depth = '31' height = '43' dim_unit = `cm` )
      ( product_id = `HT-1251` name = `Astro Laptop 1516` supplier_name = `Ultrasonic United`
        weight_measure = '4.2' weight_unit = `KG` price = '989' currency_code = `EUR` width = '30' depth = '18' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1252` name = `Astro Phone 6` supplier_name = `Ultrasonic United`
        weight_measure = '0.75' weight_unit = `KG` price = '649' currency_code = `EUR` width = '8' depth = '6' height = '1.5' dim_unit = `cm` )
      ( product_id = `HT-1253` name = `Benda Laptop 1408` supplier_name = `Ultrasonic United`
        weight_measure = '4.2' weight_unit = `KG` price = '976' currency_code = `EUR` width = '30' depth = '18' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1254` name = `Bending Screen 21HD` supplier_name = `Ultrasonic United`
        weight_measure = '15' weight_unit = `KG` price = '250' currency_code = `EUR` width = '37' depth = '12' height = '36' dim_unit = `cm` )
      ( product_id = `HT-1255` name = `Broad Screen 22HD` supplier_name = `Ultrasonic United`
        weight_measure = '16' weight_unit = `KG` price = '270' currency_code = `EUR` width = '39' depth = '12' height = '38' dim_unit = `cm` )
      ( product_id = `HT-1256` name = `Cerdik Phone 7` supplier_name = `Ultrasonic United`
        weight_measure = '0.75' weight_unit = `KG` price = '549' currency_code = `EUR` width = '9' depth = '15' height = '1.5' dim_unit = `cm` )
      ( product_id = `HT-1257` name = `Cepat Tablet 10.5` supplier_name = `Ultrasonic United`
        weight_measure = '2.8' weight_unit = `KG` price = '549' currency_code = `EUR` width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-1258` name = `Cepat Tablet 8` supplier_name = `Ultrasonic United`
        weight_measure = '2.5' weight_unit = `KG` price = '529' currency_code = `EUR` width = '38' depth = '21' height = '3.5' dim_unit = `cm` )
      ( product_id = `HT-1500` name = `Server Basic` supplier_name = `Technocom`
        weight_measure = '18' weight_unit = `KG` price = '5000' currency_code = `EUR` width = '34' depth = '35' height = '23' dim_unit = `cm` )
      ( product_id = `HT-1501` name = `Server Professional` supplier_name = `Technocom`
        weight_measure = '25' weight_unit = `KG` price = '15000' currency_code = `EUR` width = '29' depth = '30' height = '27' dim_unit = `cm` )
      ( product_id = `HT-1502` name = `Server Power Pro` supplier_name = `Technocom`
        weight_measure = '35' weight_unit = `KG` price = '25000' currency_code = `EUR` width = '22' depth = '27.3' height = '37' dim_unit = `cm` )
      ( product_id = `HT-1600` name = `Family PC Basic` supplier_name = `Titanium`
        weight_measure = '4.8' weight_unit = `KG` price = '600' currency_code = `EUR` width = '21.4' depth = '29' height = '38' dim_unit = `cm` )
      ( product_id = `HT-1601` name = `Family PC Pro` supplier_name = `Titanium`
        weight_measure = '5.3' weight_unit = `KG` price = '900' currency_code = `EUR` width = '25' depth = '31.7' height = '40.2' dim_unit = `cm` )
      ( product_id = `HT-1602` name = `Gaming Monster` supplier_name = `Titanium`
        weight_measure = '5.9' weight_unit = `KG` price = '1200' currency_code = `EUR` width = '26.5' depth = '34' height = '47' dim_unit = `cm` )
      ( product_id = `HT-1603` name = `Gaming Monster Pro` supplier_name = `Titanium`
        weight_measure = '6.8' weight_unit = `KG` price = '1700' currency_code = `EUR` width = '27' depth = '28' height = '42' dim_unit = `cm` )
      ( product_id = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3` supplier_name = `Titanium`
        weight_measure = '0.79' weight_unit = `KG` price = '249.99' currency_code = `EUR` width = '21.4' depth = '19' height = '27.6' dim_unit = `cm` )
      ( product_id = `HT-2001` name = `10" Portable DVD player` supplier_name = `Titanium`
        weight_measure = '0.84' weight_unit = `KG` price = '449.99' currency_code = `EUR` width = '24' depth = '19.5' height = '29' dim_unit = `cm` )
      ( product_id = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor` supplier_name = `Technocom`
        weight_measure = '0.72' weight_unit = `KG` price = '853.99' currency_code = `EUR` width = '21' depth = '16.5' height = '14' dim_unit = `cm` )
      ( product_id = `HT-2025` name = `CD/DVD case: 264 sleeves` supplier_name = `Titanium`
        weight_measure = '0.65' weight_unit = `KG` price = '44.99' currency_code = `EUR` width = '13' depth = '13' height = '20' dim_unit = `cm` )
      ( product_id = `HT-2026` name = `Audio/Video Cable Kit - 4m` supplier_name = `Titanium`
        weight_measure = '0.2' weight_unit = `KG` price = '29.99' currency_code = `EUR` width = '21' depth = '10.2' height = '13' dim_unit = `cm` )
      ( product_id = `HT-2027` name = `Removable CD/DVD Laser Labels` supplier_name = `Titanium`
        weight_measure = '0.15' weight_unit = `KG` price = '8.99' currency_code = `EUR` width = '5.5' depth = '2' height = '2' dim_unit = `cm` )
      ( product_id = `HT-6100` name = `Beam Breaker B-1` supplier_name = `Titanium`
        weight_measure = '1.7' weight_unit = `KG` price = '469' currency_code = `EUR` width = '30.4' depth = '23.1' height = '23' dim_unit = `cm` )
      ( product_id = `HT-6101` name = `Beam Breaker B-2` supplier_name = `Technocom`
        weight_measure = '2' weight_unit = `KG` price = '679' currency_code = `EUR` width = '30.4' depth = '23.1' height = '23' dim_unit = `cm` )
      ( product_id = `HT-6102` name = `Beam Breaker B-3` supplier_name = `Technocom`
        weight_measure = '2.5' weight_unit = `KG` price = '889' currency_code = `EUR` width = '30.4' depth = '23.1' height = '23' dim_unit = `cm` )
      ( product_id = `HT-6110` name = `Play Movie` supplier_name = `Fasttech`
        weight_measure = '2.4' weight_unit = `KG` price = '130' currency_code = `EUR` width = '37' depth = '24' height = '6' dim_unit = `cm` )
      ( product_id = `HT-6111` name = `Record Movie` supplier_name = `Fasttech`
        weight_measure = '3.1' weight_unit = `KG` price = '288' currency_code = `EUR` width = '38' depth = '26' height = '6.2' dim_unit = `cm` )
      ( product_id = `HT-6120` name = `ITelo MusicStick` supplier_name = `Fasttech`
        weight_measure = '134' weight_unit = `G` price = '45' currency_code = `EUR` width = '1.5' depth = '6' height = '1' dim_unit = `cm` )
      ( product_id = `HT-6121` name = `ITelo Jog-Mate` supplier_name = `Fasttech`
        weight_measure = '134' weight_unit = `G` price = '63' currency_code = `EUR` width = '5.1' depth = '8' height = '9.2' dim_unit = `cm` )
      ( product_id = `HT-6122` name = `Power Pro Player 40` supplier_name = `Fasttech`
        weight_measure = '266' weight_unit = `G` price = '167' currency_code = `EUR` width = '5.1' depth = '8' height = '9.2' dim_unit = `cm` )
      ( product_id = `HT-6123` name = `Power Pro Player 80` supplier_name = `Fasttech`
        weight_measure = '267' weight_unit = `G` price = '299' currency_code = `EUR` width = '4' depth = '6' height = '0.8' dim_unit = `cm` )
      ( product_id = `HT-6130` name = `Flat Watch HD32` supplier_name = `Very Best Screens`
        weight_measure = '2.6' weight_unit = `KG` price = '1459' currency_code = `EUR` width = '78' depth = '22.1' height = '55' dim_unit = `cm` )
      ( product_id = `HT-6131` name = `Flat Watch HD37` supplier_name = `Very Best Screens`
        weight_measure = '2.2' weight_unit = `KG` price = '1199' currency_code = `EUR` width = '99.1' depth = '26' height = '61' dim_unit = `cm` )
      ( product_id = `HT-6132` name = `Flat Watch HD41` supplier_name = `Very Best Screens`
        weight_measure = '1.8' weight_unit = `KG` price = '899' currency_code = `EUR` width = '128' depth = '23' height = '79.1' dim_unit = `cm` )
      ( product_id = `HT-7000` name = `Copperberry` supplier_name = `Fasttech`
        weight_measure = '0.5' weight_unit = `KG` price = '549' currency_code = `EUR` width = '8.1' depth = '13' height = '12.1' dim_unit = `cm` )
      ( product_id = `HT-7010` name = `Silverberry` supplier_name = `Fasttech`
        weight_measure = '0.5' weight_unit = `KG` price = '549' currency_code = `EUR` width = '8.1' depth = '13' height = '12.1' dim_unit = `cm` )
      ( product_id = `HT-7020` name = `Goldberry` supplier_name = `Fasttech`
        weight_measure = '0.5' weight_unit = `KG` price = '549' currency_code = `EUR` width = '8.1' depth = '13' height = '12.1' dim_unit = `cm` )
      ( product_id = `HT-7030` name = `Platinberry` supplier_name = `Fasttech`
        weight_measure = '0.5' weight_unit = `KG` price = '549' currency_code = `EUR` width = '8.1' depth = '13' height = '12.1' dim_unit = `cm` )
      ( product_id = `HT-8000` name = `ITelO FlexTop I4000` supplier_name = `Titanium`
        weight_measure = '4' weight_unit = `KG` price = '799' currency_code = `EUR` width = '31' depth = '19' height = '3.1' dim_unit = `cm` )
      ( product_id = `HT-8001` name = `ITelO FlexTop I6300c` supplier_name = `Titanium`
        weight_measure = '4.2' weight_unit = `KG` price = '799' currency_code = `EUR` width = '32' depth = '20' height = '3.4' dim_unit = `cm` )
      ( product_id = `HT-8002` name = `ITelO FlexTop I9100` supplier_name = `Titanium`
        weight_measure = '3.5' weight_unit = `KG` price = '1199' currency_code = `EUR` width = '38' depth = '21' height = '4.1' dim_unit = `cm` )
      ( product_id = `HT-8003` name = `ITelO FlexTop I9800` supplier_name = `Titanium`
        weight_measure = '3.8' weight_unit = `KG` price = '1388' currency_code = `EUR` width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9991` name = `Smartphone Leather Case` supplier_name = `Ultrasonic United`
        weight_measure = '0.02' weight_unit = `KG` price = '25' currency_code = `EUR` width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9992` name = `Smartphone Alpha` supplier_name = `Ultrasonic United`
        weight_measure = '0.75' weight_unit = `KG` price = '599' currency_code = `EUR` width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9993` name = `Mini Tablet` supplier_name = `Ultrasonic United`
        weight_measure = '3.8' weight_unit = `KG` price = '833' currency_code = `EUR` width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9994` name = `Camcorder View` supplier_name = `Ultrasonic United`
        weight_measure = '3.8' weight_unit = `KG` price = '1388' currency_code = `EUR` width = '48' depth = '31' height = '27' dim_unit = `cm` )
      ( product_id = `HT-9995` name = `Tablet Pouch` supplier_name = `Titanium`
        weight_measure = '0.03' weight_unit = `KG` price = '20' currency_code = `EUR` width = '25' depth = '40' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9996` name = `Tablet Pouch` supplier_name = `Titanium`
        weight_measure = '0.03' weight_unit = `KG` price = '20' currency_code = `EUR` width = '25' depth = '40' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9997` name = `e-Book Reader ReadMe` supplier_name = `Titanium`
        weight_measure = '3.8' weight_unit = `KG` price = '33' currency_code = `EUR` width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9998` name = `Smartphone Beta` supplier_name = `Titanium`
        weight_measure = '0.75' weight_unit = `KG` price = '30' currency_code = `EUR` width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9999` name = `Maxi Tablet` supplier_name = `Titanium`
        weight_measure = '3.8' weight_unit = `KG` price = '749' currency_code = `EUR` width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `PF-1000` name = `Flyer` supplier_name = `Titanium`
        weight_measure = '0.01' weight_unit = `KG` price = '0' currency_code = `EUR` width = '46' depth = '30' height = '3' dim_unit = `cm` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        " the original's local Formatter.js weightState is the framework's curated formatter module (see the NOTE + POST_171 deviations)
        )->a( n = `core:require` v = |\{Formatter: 'z2ui5/model/formatter'\}|

        " sticky + popinLayout are set imperatively by the original controller (onSelect / onPopinLayoutChanged) - bound properties here
        )->open( `Table`
            )->a( n = `id`          v = `idProductsTable`
            )->a( n = `inset`       v = `false`
            )->a( n = `items`       v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|
            )->a( n = `sticky`      v = client->_bind( t_sticky )
            )->a( n = `popinLayout` v = |\{= ${ client->_bind( popin_key ) } === 'GridLarge' \|\| ${ client->_bind( popin_key ) } === 'GridSmall' ? ${ client->_bind( popin_key ) } : 'Block' \}|

            )->open( `headerToolbar`
                )->open( `OverflowToolbar`
                    )->open( `content`
                        )->leaf( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->leaf( `ToolbarSpacer`

                        " the original change handler's PopinLayout switch lives in the Table's popinLayout expression binding
                        )->open( `ComboBox`
                            )->a( n = `id`          v = `idPopinLayout`
                            )->a( n = `placeholder` v = `Popin layout options`
                            )->a( n = `selectedKey` v = client->_bind( popin_key )

                            )->open( `items`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Block`
                                    )->a( n = `key`  v = `Block`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Grid Large`
                                    )->a( n = `key`  v = `GridLarge`
                                )->leaf( n = `Item` ns = `core`
                                    )->a( n = `text` v = `Grid Small`
                                    )->a( n = `key`  v = `GridSmall`

                            )->shut(
                        )->shut(
                        )->leaf( `Label`
                            )->a( n = `text` v = `Sticky options:`
                        )->leaf( `CheckBox`
                            )->a( n = `text`   v = `ColumnHeaders`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = VALUE #( ( `${$source>/text}` ) ( `${$parameters>/selected}` ) ) )
                        )->leaf( `CheckBox`
                            )->a( n = `text`   v = `HeaderToolbar`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = VALUE #( ( `${$source>/text}` ) ( `${$parameters>/selected}` ) ) )
                        )->leaf( `CheckBox`
                            )->a( n = `text`   v = `InfoToolbar`
                            )->a( n = `select` v = client->_event( val   = `STICKY_SELECT`
                                                                   t_arg = VALUE #( ( `${$source>/text}` ) ( `${$parameters>/selected}` ) ) )
                        " the original press handler (infoToolbar.setVisible(!pressed)) is the visible expression binding on the infoToolbar below
                        )->leaf( `ToggleButton`
                            )->a( n = `id`      v = `toggleInfoToolbar`
                            )->a( n = `text`    v = `Hide/Show InfoToolbar`
                            )->a( n = `pressed` v = client->_bind( toggle_pressed )

                    )->shut(
                )->shut(
            )->shut(
            )->open( `infoToolbar`
                )->open( `OverflowToolbar`
                    )->a( n = `visible` v = |\{= !${ client->_bind( toggle_pressed ) } \}|

                    )->leaf( `Label`
                        )->a( n = `text` v = `Wide range of available products`

                )->shut(
            )->shut(
            )->open( `columns`
                )->open( `Column`
                    )->a( n = `width` v = `12em`

                    " p:ColumnAIAction dependents dropped - plugin class newer than 1.71, see DROPPED_171 (as app 401)
                    )->leaf( `Text`
                        )->a( n = `text` v = `Product`

                )->shut(
                )->open( `Column`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Supplier`

                )->shut(
                )->open( `Column`
                    )->a( n = `minScreenWidth` v = `Desktop`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `End`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Dimensions`

                )->shut(
                )->open( `Column`
                    )->a( n = `minScreenWidth` v = `Desktop`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `Center`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Weight`

                )->shut(
                )->open( `Column`
                    )->a( n = `hAlign` v = `End`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Price`

                )->shut(
            )->shut(
            )->open( `items`
                )->open( `ColumnListItem`
                    )->a( n = `vAlign` v = `Middle`

                    )->open( `cells`
                        )->leaf( `ObjectIdentifier`
                            )->a( n = `title` v = `{NAME}`
                            )->a( n = `text`  v = `{PRODUCT_ID}`
                        )->leaf( `Text`
                            )->a( n = `text` v = `{SUPPLIER_NAME}`
                        )->leaf( `Text`
                            )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                        )->leaf( `ObjectNumber`
                            )->a( n = `number` v = `{WEIGHT_MEASURE}`
                            )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                            )->a( n = `state`  v = |\{ parts: [ \{ path: 'WEIGHT_MEASURE' \}, \{ path: 'WEIGHT_UNIT' \} ], formatter: 'Formatter.weightState' \}|
                        )->leaf( `ObjectNumber`
                            )->a( n = `number` v = |\{ parts: [ \{ path: 'PRICE' \}, \{ path: 'CURRENCY_CODE' \} ], type: 'sap.ui.model.type.Currency', formatOptions: \{ showMeasure: false \} \}|
                            )->a( n = `unit`   v = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    DATA selected TYPE abap_bool.

    CASE client->get( )-event.

      WHEN `STICKY_SELECT`.
        DATA(sticky_text) = client->get_event_arg( ).
        selected = client->get_event_arg( 2 ).
        IF selected = abap_true.
          INSERT sticky_text INTO TABLE t_sticky.
        ELSE.
          DELETE t_sticky WHERE table_line = sticky_text.
        ENDIF.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
