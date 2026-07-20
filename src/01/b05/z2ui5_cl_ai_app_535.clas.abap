CLASS z2ui5_cl_ai_app_535 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id     TYPE string,
        supplier_name  TYPE string,
        weight_measure TYPE p LENGTH 8 DECIMALS 3,
        weight_unit    TYPE string,
        name           TYPE string,
        currency_code  TYPE string,
        price          TYPE p LENGTH 8 DECIMALS 2,
        width          TYPE p LENGTH 4 DECIMALS 1,
        depth          TYPE p LENGTH 4 DECIMALS 1,
        height         TYPE p LENGTH 4 DECIMALS 1,
        dim_unit       TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA popin_layout TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.
    METHODS popup_message_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_535 IMPLEMENTATION.

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

    t_products = VALUE #(
      ( product_id = `HT-1000` supplier_name = `Very Best Screens` weight_measure = '4.2' weight_unit = `KG` name = `Notebook Basic 15` currency_code = `EUR` price = '956' width = '30' depth = '18' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1001` supplier_name = `Very Best Screens` weight_measure = '4.5' weight_unit = `KG` name = `Notebook Basic 17` currency_code = `EUR` price = '1249' width = '29' depth = '17' height = '3.1' dim_unit = `cm` )
      ( product_id = `HT-1002` supplier_name = `Very Best Screens` weight_measure = '4.2' weight_unit = `KG` name = `Notebook Basic 18` currency_code = `EUR` price = '1570' width = '28' depth = '19' height = '2.5' dim_unit = `cm` )
      ( product_id = `HT-1003` supplier_name = `Smartcards` weight_measure = '4.2' weight_unit = `KG` name = `Notebook Basic 19` currency_code = `EUR` price = '1650' width = '32' depth = '21' height = '4' dim_unit = `cm` )
      ( product_id = `HT-1007` supplier_name = `Technocom` weight_measure = '0.2' weight_unit = `KG` name = `ITelO Vault` currency_code = `EUR` price = '299' width = '32' depth = '22' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1010` supplier_name = `Very Best Screens` weight_measure = '4.3' weight_unit = `KG` name = `Notebook Professional 15` currency_code = `EUR` price = '1999' width = '33' depth = '20' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1011` supplier_name = `Very Best Screens` weight_measure = '4.1' weight_unit = `KG` name = `Notebook Professional 17` currency_code = `EUR` price = '2299' width = '33' depth = '23' height = '2' dim_unit = `cm` )
      ( product_id = `HT-1020` supplier_name = `Technocom` weight_measure = '0.16' weight_unit = `KG` name = `ITelO Vault Net` currency_code = `EUR` price = '459' width = '10' depth = '1.8' height = '17' dim_unit = `cm` )
      ( product_id = `HT-1021` supplier_name = `Technocom` weight_measure = '0.18' weight_unit = `KG` name = `ITelO Vault SAT` currency_code = `EUR` price = '149' width = '11' depth = '1.7' height = '18' dim_unit = `cm` )
      ( product_id = `HT-1022` supplier_name = `Technocom` weight_measure = '0.2' weight_unit = `KG` name = `Comfort Easy` currency_code = `EUR` price = '1679' width = '84' depth = '1.5' height = '14' dim_unit = `cm` )
      ( product_id = `HT-1023` supplier_name = `Technocom` weight_measure = '0.8' weight_unit = `KG` name = `Comfort Senior` currency_code = `EUR` price = '512' width = '80' depth = '1.6' height = '13' dim_unit = `cm` )
      ( product_id = `HT-1030` supplier_name = `Very Best Screens` weight_measure = '21' weight_unit = `KG` name = `Ergo Screen E-I` currency_code = `EUR` price = '230' width = '37' depth = '12' height = '36' dim_unit = `cm` )
      ( product_id = `HT-1031` supplier_name = `Very Best Screens` weight_measure = '21' weight_unit = `KG` name = `Ergo Screen E-II` currency_code = `EUR` price = '285' width = '40.8' depth = '19' height = '43' dim_unit = `cm` )
      ( product_id = `HT-1032` supplier_name = `Very Best Screens` weight_measure = '21' weight_unit = `KG` name = `Ergo Screen E-III` currency_code = `EUR` price = '345' width = '40.8' depth = '19' height = '43' dim_unit = `cm` )
      ( product_id = `HT-1035` supplier_name = `Very Best Screens` weight_measure = '14' weight_unit = `KG` name = `Flat Basic` currency_code = `EUR` price = '399' width = '39' depth = '20' height = '41' dim_unit = `cm` )
      ( product_id = `HT-1036` supplier_name = `Very Best Screens` weight_measure = '15' weight_unit = `KG` name = `Flat Future` currency_code = `EUR` price = '430' width = '45' depth = '26' height = '46' dim_unit = `cm` )
      ( product_id = `HT-1037` supplier_name = `Very Best Screens` weight_measure = '17' weight_unit = `KG` name = `Flat XL` currency_code = `EUR` price = '1230' width = '54.5' depth = '22.1' height = '39.1' dim_unit = `cm` )
      ( product_id = `HT-1040` supplier_name = `Alpha Printers` weight_measure = '32' weight_unit = `KG` name = `Laser Professional Eco` currency_code = `EUR` price = '830' width = '51' depth = '46' height = '30' dim_unit = `cm` )
      ( product_id = `HT-1041` supplier_name = `Alpha Printers` weight_measure = '23' weight_unit = `KG` name = `Laser Basic` currency_code = `EUR` price = '490' width = '48' depth = '42' height = '26' dim_unit = `cm` )
      ( product_id = `HT-1042` supplier_name = `Alpha Printers` weight_measure = '17' weight_unit = `KG` name = `Laser Allround` currency_code = `EUR` price = '349' width = '53' depth = '50' height = '65' dim_unit = `cm` )
      ( product_id = `HT-1050` supplier_name = `Alpha Printers` weight_measure = '3' weight_unit = `KG` name = `Ultra Jet Super Color` currency_code = `EUR` price = '139' width = '41' depth = '41' height = '28' dim_unit = `cm` )
      ( product_id = `HT-1051` supplier_name = `Printer for All` weight_measure = '1.9' weight_unit = `KG` name = `Ultra Jet Mobile` currency_code = `EUR` price = '99' width = '46' depth = '32' height = '25' dim_unit = `cm` )
      ( product_id = `HT-1052` supplier_name = `Printer for All` weight_measure = '18' weight_unit = `KG` name = `Ultra Jet Super Highspeed` currency_code = `EUR` price = '170' width = '41' depth = '41' height = '28' dim_unit = `cm` )
      ( product_id = `HT-1055` supplier_name = `Printer for All` weight_measure = '6.3' weight_unit = `KG` name = `Multi Print` currency_code = `EUR` price = '99' width = '55' depth = '45' height = '29' dim_unit = `cm` )
      ( product_id = `HT-1056` supplier_name = `Printer for All` weight_measure = '4.3' weight_unit = `KG` name = `Multi Color` currency_code = `EUR` price = '119' width = '51' depth = '41.3' height = '22' dim_unit = `cm` )
      ( product_id = `HT-1060` supplier_name = `Oxynum` weight_measure = '0.09' weight_unit = `KG` name = `Cordless Mouse` currency_code = `EUR` price = '9' width = '6' depth = '14.5' height = '3.5' dim_unit = `cm` )
      ( product_id = `HT-1061` supplier_name = `Oxynum` weight_measure = '0.09' weight_unit = `KG` name = `Speed Mouse` currency_code = `EUR` price = '7' width = '7' depth = '15' height = '3.1' dim_unit = `cm` )
      ( product_id = `HT-1062` supplier_name = `Oxynum` weight_measure = '0.03' weight_unit = `KG` name = `Track Mouse` currency_code = `EUR` price = '11' width = '3' depth = '7' height = '4' dim_unit = `cm` )
      ( product_id = `HT-1063` supplier_name = `Oxynum` weight_measure = '2.1' weight_unit = `KG` name = `Ergonomic Keyboard` currency_code = `EUR` price = '14' width = '50' depth = '21' height = '3.5' dim_unit = `cm` )
      ( product_id = `HT-1064` supplier_name = `Oxynum` weight_measure = '1.8' weight_unit = `KG` name = `Internet Keyboard` currency_code = `EUR` price = '16' width = '52' depth = '25' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1065` supplier_name = `Oxynum` weight_measure = '2.3' weight_unit = `KG` name = `Media Keyboard` currency_code = `EUR` price = '26' width = '51.4' depth = '23' height = '4' dim_unit = `cm` )
      ( product_id = `HT-1066` supplier_name = `Oxynum` weight_measure = '80' weight_unit = `G` name = `Mousepad` currency_code = `EUR` price = '6.99' width = '15' depth = '6' height = '0.2' dim_unit = `cm` )
      ( product_id = `HT-1067` supplier_name = `Oxynum` weight_measure = '80' weight_unit = `G` name = `Ergo Mousepad` currency_code = `EUR` price = '8.99' width = '15' depth = '6' height = '0.2' dim_unit = `cm` )
      ( product_id = `HT-1068` supplier_name = `Fasttech` weight_measure = '90' weight_unit = `G` name = `Designer Mousepad` currency_code = `EUR` price = '12.99' width = '24' depth = '24' height = '0.6' dim_unit = `cm` )
      ( product_id = `HT-1069` supplier_name = `Fasttech` weight_measure = '45' weight_unit = `G` name = `Universal card reader` currency_code = `EUR` price = '14' width = '6' depth = '6' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1070` supplier_name = `Ultrasonic United` weight_measure = '0.255' weight_unit = `KG` name = `Proctra X` currency_code = `EUR` price = '70.9' width = '22' depth = '35' height = '17' dim_unit = `cm` )
      ( product_id = `HT-1071` supplier_name = `Ultrasonic United` weight_measure = '0.3' weight_unit = `KG` name = `Gladiator MX` currency_code = `EUR` price = '81.7' width = '22' depth = '35' height = '17' dim_unit = `cm` )
      ( product_id = `HT-1072` supplier_name = `Ultrasonic United` weight_measure = '0.4' weight_unit = `KG` name = `Hurricane GX` currency_code = `EUR` price = '101.2' width = '22' depth = '35' height = '17' dim_unit = `cm` )
      ( product_id = `HT-1073` supplier_name = `Smartcards` weight_measure = '0.4' weight_unit = `KG` name = `Hurricane GX/LN` currency_code = `EUR` price = '139.99' width = '22' depth = '35' height = '17' dim_unit = `cm` )
      ( product_id = `HT-1080` supplier_name = `Printer for All` weight_measure = '2.3' weight_unit = `KG` name = `Photo Scan` currency_code = `EUR` price = '129' width = '34' depth = '48' height = '5' dim_unit = `cm` )
      ( product_id = `HT-1081` supplier_name = `Printer for All` weight_measure = '2.4' weight_unit = `KG` name = `Power Scan` currency_code = `EUR` price = '89' width = '31' depth = '43' height = '7' dim_unit = `cm` )
      ( product_id = `HT-1082` supplier_name = `Printer for All` weight_measure = '3.2' weight_unit = `KG` name = `Jet Scan Professional` currency_code = `EUR` price = '169' width = '33' depth = '41' height = '12' dim_unit = `cm` )
      ( product_id = `HT-1083` supplier_name = `Printer for All` weight_measure = '3.2' weight_unit = `KG` name = `Jet Scan Professional` currency_code = `EUR` price = '189' width = '35' depth = '40' height = '10' dim_unit = `cm` )
      ( product_id = `HT-1085` supplier_name = `Alpha Printers` weight_measure = '23.2' weight_unit = `KG` name = `Copymaster` currency_code = `EUR` price = '1499' width = '45' depth = '42' height = '22' dim_unit = `cm` )
      ( product_id = `HT-1090` supplier_name = `Speaker Experts` weight_measure = '3' weight_unit = `KG` name = `Surround Sound` currency_code = `EUR` price = '39' width = '12' depth = '10' height = '16' dim_unit = `cm` )
      ( product_id = `HT-1091` supplier_name = `Speaker Experts` weight_measure = '1.4' weight_unit = `KG` name = `Blaster Extreme` currency_code = `EUR` price = '26' width = '13' depth = '11' height = '17.5' dim_unit = `cm` )
      ( product_id = `HT-1092` supplier_name = `Speaker Experts` weight_measure = '2.1' weight_unit = `KG` name = `Sound Booster` currency_code = `EUR` price = '45' width = '12.4' depth = '10.4' height = '18.1' dim_unit = `cm` )
      ( product_id = `HT-1100` supplier_name = `Technocom` weight_measure = '1.2' weight_unit = `KG` name = `Smart Office` currency_code = `EUR` price = '89.9' width = '15' depth = '6.5' height = '2.1' dim_unit = `cm` )
      ( product_id = `HT-1101` supplier_name = `Technocom` weight_measure = '0.8' weight_unit = `KG` name = `Smart Design` currency_code = `EUR` price = '79.9' width = '14' depth = '6.7' height = '24' dim_unit = `cm` )
      ( product_id = `HT-1102` supplier_name = `Technocom` weight_measure = '0.8' weight_unit = `KG` name = `Smart Network` currency_code = `EUR` price = '69' width = '16' depth = '6' height = '27' dim_unit = `cm` )
      ( product_id = `HT-1103` supplier_name = `Technocom` weight_measure = '0.8' weight_unit = `KG` name = `Smart Multimedia` currency_code = `EUR` price = '77' width = '11' depth = '3.4' height = '22' dim_unit = `cm` )
      ( product_id = `HT-1104` supplier_name = `Technocom` weight_measure = '1.1' weight_unit = `KG` name = `Smart Games` currency_code = `EUR` price = '55' width = '10' depth = '3' height = '30' dim_unit = `cm` )
      ( product_id = `HT-1105` supplier_name = `Brainsoft` weight_measure = '0.7' weight_unit = `KG` name = `Smart Internet Antivirus` currency_code = `EUR` price = '29' width = '16' depth = '4' height = '21' dim_unit = `cm` )
      ( product_id = `HT-1106` supplier_name = `Brainsoft` weight_measure = '0.9' weight_unit = `KG` name = `Smart Firewall` currency_code = `EUR` price = '34' width = '17.9' depth = '4.2' height = '23.1' dim_unit = `cm` )
      ( product_id = `HT-1107` supplier_name = `Brainsoft` weight_measure = '0.5' weight_unit = `KG` name = `Smart Money` currency_code = `EUR` price = '29.9' width = '12' depth = '1.5' height = '19' dim_unit = `cm` )
      ( product_id = `HT-1110` supplier_name = `Red Point Stores` weight_measure = '0.03' weight_unit = `KG` name = `PC Lock` currency_code = `EUR` price = '8.9' width = '20' depth = '8' height = '4.3' dim_unit = `cm` )
      ( product_id = `HT-1111` supplier_name = `Red Point Stores` weight_measure = '0.02' weight_unit = `KG` name = `Notebook Lock` currency_code = `EUR` price = '6.9' width = '31' depth = '9' height = '7' dim_unit = `cm` )
      ( product_id = `HT-1112` supplier_name = `Red Point Stores` weight_measure = '0.075' weight_unit = `KG` name = `Web cam reality` currency_code = `EUR` price = '39' width = '9' depth = '8.2' height = '1.3' dim_unit = `cm` )
      ( product_id = `HT-1113` supplier_name = `Red Point Stores` weight_measure = '0.05' weight_unit = `KG` name = `Screen clean` currency_code = `EUR` price = '2.3' width = '2' depth = '2' height = '0.1' dim_unit = `cm` )
      ( product_id = `HT-1114` supplier_name = `Red Point Stores` weight_measure = '1.8' weight_unit = `KG` name = `Fabric bag professional` currency_code = `EUR` price = '31' width = '42' depth = '32' height = '7' dim_unit = `cm` )
      ( product_id = `HT-1115` supplier_name = `Red Point Stores` weight_measure = '0.45' weight_unit = `KG` name = `Wireless DSL Router` currency_code = `EUR` price = '49' width = '19.3' depth = '18' height = '5' dim_unit = `cm` )
      ( product_id = `HT-1116` supplier_name = `Red Point Stores` weight_measure = '0.45' weight_unit = `KG` name = `Wireless DSL Router / Repeater` currency_code = `EUR` price = '59' width = '19.3' depth = '18' height = '5' dim_unit = `cm` )
      ( product_id = `HT-1117` supplier_name = `Technocom` weight_measure = '0.45' weight_unit = `KG` name = `Wireless DSL Router / Repeater and Print Server` currency_code = `EUR` price = '69' width = '19.3' depth = '18' height = '5' dim_unit = `cm` )
      ( product_id = `HT-1118` supplier_name = `Technocom` weight_measure = '0.015' weight_unit = `KG` name = `USB Stick` currency_code = `EUR` price = '35' width = '1.5' depth = '8.7' height = '1.2' dim_unit = `cm` )
      ( product_id = `HT-1120` supplier_name = `Technocom` weight_measure = '1' weight_unit = `KG` name = `Cordless Bluetooth Keyboard, english international` currency_code = `EUR` price = '29' width = '51.4' depth = '23' height = '4' dim_unit = `cm` )
      ( product_id = `HT-1137` supplier_name = `Technocom` weight_measure = '18' weight_unit = `KG` name = `Flat XXL` currency_code = `EUR` price = '1430' width = '54' depth = '22' height = '38' dim_unit = `cm` )
      ( product_id = `HT-1138` supplier_name = `Technocom` weight_measure = '0.02' weight_unit = `KG` name = `Pocket Mouse` currency_code = `EUR` price = '23' width = '0.3' depth = '0.5' height = '1' dim_unit = `cm` )
      ( product_id = `HT-1210` supplier_name = `Technocom` weight_measure = '2.3' weight_unit = `KG` name = `PC Power Station` currency_code = `EUR` price = '2399' width = '28' depth = '31' height = '43' dim_unit = `cm` )
      ( product_id = `HT-1500` supplier_name = `Technocom` weight_measure = '18' weight_unit = `KG` name = `Server Basic` currency_code = `EUR` price = '5000' width = '34' depth = '35' height = '23' dim_unit = `cm` )
      ( product_id = `HT-1501` supplier_name = `Technocom` weight_measure = '25' weight_unit = `KG` name = `Server Professional` currency_code = `EUR` price = '15000' width = '29' depth = '30' height = '27' dim_unit = `cm` )
      ( product_id = `HT-1502` supplier_name = `Technocom` weight_measure = '35' weight_unit = `KG` name = `Server Power Pro` currency_code = `EUR` price = '25000' width = '22' depth = '27.3' height = '37' dim_unit = `cm` )
      ( product_id = `HT-6130` supplier_name = `Very Best Screens` weight_measure = '2.6' weight_unit = `KG` name = `Flat Watch HD32` currency_code = `EUR` price = '1459' width = '78' depth = '22.1' height = '55' dim_unit = `cm` )
      ( product_id = `HT-6131` supplier_name = `Very Best Screens` weight_measure = '2.2' weight_unit = `KG` name = `Flat Watch HD37` currency_code = `EUR` price = '1199' width = '99.1' depth = '26' height = '61' dim_unit = `cm` )
      ( product_id = `HT-6132` supplier_name = `Very Best Screens` weight_measure = '1.8' weight_unit = `KG` name = `Flat Watch HD41` currency_code = `EUR` price = '899' width = '128' depth = '23' height = '79.1' dim_unit = `cm` )
      ( product_id = `HT-7030` supplier_name = `Fasttech` weight_measure = '0.5' weight_unit = `KG` name = `Platinberry` currency_code = `EUR` price = '549' width = '8.1' depth = '13' height = '12.1' dim_unit = `cm` )
      ( product_id = `HT-7020` supplier_name = `Fasttech` weight_measure = '0.5' weight_unit = `KG` name = `Goldberry` currency_code = `EUR` price = '549' width = '8.1' depth = '13' height = '12.1' dim_unit = `cm` )
      ( product_id = `HT-7010` supplier_name = `Fasttech` weight_measure = '0.5' weight_unit = `KG` name = `Silverberry` currency_code = `EUR` price = '549' width = '8.1' depth = '13' height = '12.1' dim_unit = `cm` )
      ( product_id = `HT-7000` supplier_name = `Fasttech` weight_measure = '0.5' weight_unit = `KG` name = `Copperberry` currency_code = `EUR` price = '549' width = '8.1' depth = '13' height = '12.1' dim_unit = `cm` )
      ( product_id = `HT-1095` supplier_name = `Fasttech` weight_measure = '80' weight_unit = `G` name = `Lovely Sound 5.1 Wireless` currency_code = `EUR` price = '49' width = '24' depth = '19' height = '23' dim_unit = `cm` )
      ( product_id = `HT-1096` supplier_name = `Fasttech` weight_measure = '130' weight_unit = `G` name = `Lovely Sound 5.1` currency_code = `EUR` price = '39' width = '25' depth = '17' height = '19' dim_unit = `cm` )
      ( product_id = `HT-1097` supplier_name = `Fasttech` weight_measure = '60' weight_unit = `G` name = `Lovely Sound Stereo` currency_code = `EUR` price = '29' width = '21.3' depth = '2.4' height = '19.7' dim_unit = `cm` )
      ( product_id = `HT-6123` supplier_name = `Fasttech` weight_measure = '267' weight_unit = `G` name = `Power Pro Player 80` currency_code = `EUR` price = '299' width = '4' depth = '6' height = '0.8' dim_unit = `cm` )
      ( product_id = `HT-6122` supplier_name = `Fasttech` weight_measure = '266' weight_unit = `G` name = `Power Pro Player 40` currency_code = `EUR` price = '167' width = '5.1' depth = '8' height = '9.2' dim_unit = `cm` )
      ( product_id = `HT-6121` supplier_name = `Fasttech` weight_measure = '134' weight_unit = `G` name = `ITelo Jog-Mate` currency_code = `EUR` price = '63' width = '5.1' depth = '8' height = '9.2' dim_unit = `cm` )
      ( product_id = `HT-6120` supplier_name = `Fasttech` weight_measure = '134' weight_unit = `G` name = `ITelo MusicStick` currency_code = `EUR` price = '45' width = '1.5' depth = '6' height = '1' dim_unit = `cm` )
      ( product_id = `HT-6111` supplier_name = `Fasttech` weight_measure = '3.1' weight_unit = `KG` name = `Record Movie` currency_code = `EUR` price = '288' width = '38' depth = '26' height = '6.2' dim_unit = `cm` )
      ( product_id = `HT-6110` supplier_name = `Fasttech` weight_measure = '2.4' weight_unit = `KG` name = `Play Movie` currency_code = `EUR` price = '130' width = '37' depth = '24' height = '6' dim_unit = `cm` )
      ( product_id = `HT-6102` supplier_name = `Technocom` weight_measure = '2.5' weight_unit = `KG` name = `Beam Breaker B-3` currency_code = `EUR` price = '889' width = '30.4' depth = '23.1' height = '23' dim_unit = `cm` )
      ( product_id = `HT-6101` supplier_name = `Technocom` weight_measure = '2' weight_unit = `KG` name = `Beam Breaker B-2` currency_code = `EUR` price = '679' width = '30.4' depth = '23.1' height = '23' dim_unit = `cm` )
      ( product_id = `HT-2002` supplier_name = `Technocom` weight_measure = '0.72' weight_unit = `KG` name = `Portable DVD Player with 9" LCD Monitor` currency_code = `EUR` price = '853.99' width = '21' depth = '16.5' height = '14' dim_unit = `cm` )
      ( product_id = `HT-6100` supplier_name = `Titanium` weight_measure = '1.7' weight_unit = `KG` name = `Beam Breaker B-1` currency_code = `EUR` price = '469' width = '30.4' depth = '23.1' height = '23' dim_unit = `cm` )
      ( product_id = `HT-2027` supplier_name = `Titanium` weight_measure = '0.15' weight_unit = `KG` name = `Removable CD/DVD Laser Labels` currency_code = `EUR` price = '8.99' width = '5.5' depth = '2' height = '2' dim_unit = `cm` )
      ( product_id = `HT-2026` supplier_name = `Titanium` weight_measure = '0.2' weight_unit = `KG` name = `Audio/Video Cable Kit - 4m` currency_code = `EUR` price = '29.99' width = '21' depth = '10.2' height = '13' dim_unit = `cm` )
      ( product_id = `HT-2025` supplier_name = `Titanium` weight_measure = '0.65' weight_unit = `KG` name = `CD/DVD case: 264 sleeves` currency_code = `EUR` price = '44.99' width = '13' depth = '13' height = '20' dim_unit = `cm` )
      ( product_id = `HT-2001` supplier_name = `Titanium` weight_measure = '0.84' weight_unit = `KG` name = `10" Portable DVD player` currency_code = `EUR` price = '449.99' width = '24' depth = '19.5' height = '29' dim_unit = `cm` )
      ( product_id = `HT-2000` supplier_name = `Titanium` weight_measure = '0.79' weight_unit = `KG` name = `7" Widescreen Portable DVD Player w MP3` currency_code = `EUR` price = '249.99' width = '21.4' depth = '19' height = '27.6' dim_unit = `cm` )
      ( product_id = `HT-1603` supplier_name = `Titanium` weight_measure = '6.8' weight_unit = `KG` name = `Gaming Monster Pro` currency_code = `EUR` price = '1700' width = '27' depth = '28' height = '42' dim_unit = `cm` )
      ( product_id = `HT-1602` supplier_name = `Titanium` weight_measure = '5.9' weight_unit = `KG` name = `Gaming Monster` currency_code = `EUR` price = '1200' width = '26.5' depth = '34' height = '47' dim_unit = `cm` )
      ( product_id = `HT-1601` supplier_name = `Titanium` weight_measure = '5.3' weight_unit = `KG` name = `Family PC Pro` currency_code = `EUR` price = '900' width = '25' depth = '31.7' height = '40.2' dim_unit = `cm` )
      ( product_id = `HT-1600` supplier_name = `Titanium` weight_measure = '4.8' weight_unit = `KG` name = `Family PC Basic` currency_code = `EUR` price = '600' width = '21.4' depth = '29' height = '38' dim_unit = `cm` )
      ( product_id = `HT-1119` supplier_name = `Titanium` weight_measure = '88' weight_unit = `G` name = `Travel Adapter` currency_code = `EUR` price = '79' width = '2' depth = '3.1' height = '3.9' dim_unit = `cm` )
      ( product_id = `HT-8000` supplier_name = `Titanium` weight_measure = '4' weight_unit = `KG` name = `ITelO FlexTop I4000` currency_code = `EUR` price = '799' width = '31' depth = '19' height = '3.1' dim_unit = `cm` )
      ( product_id = `HT-8001` supplier_name = `Titanium` weight_measure = '4.2' weight_unit = `KG` name = `ITelO FlexTop I6300c` currency_code = `EUR` price = '799' width = '32' depth = '20' height = '3.4' dim_unit = `cm` )
      ( product_id = `HT-8002` supplier_name = `Titanium` weight_measure = '3.5' weight_unit = `KG` name = `ITelO FlexTop I9100` currency_code = `EUR` price = '1199' width = '38' depth = '21' height = '4.1' dim_unit = `cm` )
      ( product_id = `HT-8003` supplier_name = `Titanium` weight_measure = '3.8' weight_unit = `KG` name = `ITelO FlexTop I9800` currency_code = `EUR` price = '1388' width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `PF-1000` supplier_name = `Titanium` weight_measure = '0.01' weight_unit = `KG` name = `Flyer` currency_code = `EUR` price = '0' width = '46' depth = '30' height = '3' dim_unit = `cm` )
      ( product_id = `HT-9999` supplier_name = `Titanium` weight_measure = '3.8' weight_unit = `KG` name = `Maxi Tablet` currency_code = `EUR` price = '749' width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9998` supplier_name = `Titanium` weight_measure = '0.75' weight_unit = `KG` name = `Smartphone Beta` currency_code = `EUR` price = '30' width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9997` supplier_name = `Titanium` weight_measure = '3.8' weight_unit = `KG` name = `e-Book Reader ReadMe` currency_code = `EUR` price = '33' width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9996` supplier_name = `Titanium` weight_measure = '0.03' weight_unit = `KG` name = `Tablet Pouch` currency_code = `EUR` price = '20' width = '25' depth = '40' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9995` supplier_name = `Titanium` weight_measure = '0.02' weight_unit = `KG` name = `Smartphone Cover` currency_code = `EUR` price = '15' width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9994` supplier_name = `Ultrasonic United` weight_measure = '3.8' weight_unit = `KG` name = `Camcorder View` currency_code = `EUR` price = '1388' width = '48' depth = '31' height = '27' dim_unit = `cm` )
      ( product_id = `HT-9993` supplier_name = `Ultrasonic United` weight_measure = '3.8' weight_unit = `KG` name = `Mini Tablet` currency_code = `EUR` price = '833' width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9992` supplier_name = `Ultrasonic United` weight_measure = '0.75' weight_unit = `KG` name = `Smartphone Alpha` currency_code = `EUR` price = '599' width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-9991` supplier_name = `Ultrasonic United` weight_measure = '0.02' weight_unit = `KG` name = `Smartphone Leather Case` currency_code = `EUR` price = '25' width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-1251` supplier_name = `Ultrasonic United` weight_measure = '4.2' weight_unit = `KG` name = `Astro Laptop 1516` currency_code = `EUR` price = '989' width = '30' depth = '18' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1252` supplier_name = `Ultrasonic United` weight_measure = '0.75' weight_unit = `KG` name = `Astro Phone 6` currency_code = `EUR` price = '649' width = '8' depth = '6' height = '1.5' dim_unit = `cm` )
      ( product_id = `HT-1253` supplier_name = `Ultrasonic United` weight_measure = '4.2' weight_unit = `KG` name = `Benda Laptop 1408` currency_code = `EUR` price = '976' width = '30' depth = '18' height = '3' dim_unit = `cm` )
      ( product_id = `HT-1254` supplier_name = `Ultrasonic United` weight_measure = '15' weight_unit = `KG` name = `Bending Screen 21HD` currency_code = `EUR` price = '250' width = '37' depth = '12' height = '36' dim_unit = `cm` )
      ( product_id = `HT-1255` supplier_name = `Ultrasonic United` weight_measure = '16' weight_unit = `KG` name = `Broad Screen 22HD` currency_code = `EUR` price = '270' width = '39' depth = '12' height = '38' dim_unit = `cm` )
      ( product_id = `HT-1256` supplier_name = `Ultrasonic United` weight_measure = '0.75' weight_unit = `KG` name = `Cerdik Phone 7` currency_code = `EUR` price = '549' width = '9' depth = '15' height = '1.5' dim_unit = `cm` )
      ( product_id = `HT-1257` supplier_name = `Ultrasonic United` weight_measure = '2.8' weight_unit = `KG` name = `Cepat Tablet 10.5` currency_code = `EUR` price = '549' width = '48' depth = '31' height = '4.5' dim_unit = `cm` )
      ( product_id = `HT-1258` supplier_name = `Ultrasonic United` weight_measure = '2.5' weight_unit = `KG` name = `Cepat Tablet 8` currency_code = `EUR` price = '529' width = '38' depth = '21' height = '3.5' dim_unit = `cm` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `core:require` v = `{Formatter:'z2ui5/model/formatter'}`

        )->open( `Table`
            )->a( n = `id`          v = `idProductsTable`
            )->a( n = `inset`       v = `false`
            )->a( n = `items`       v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|
            " the controller's onPopinLayoutChanged switch lives in this expression binding (as app 534) - never emits an empty enum value
            )->a( n = `popinLayout` v = |\{= ${ client->_bind( popin_layout ) } === 'GridLarge' \|\| ${ client->_bind( popin_layout ) } === 'GridSmall' ? ${ client->_bind( popin_layout ) } : 'Block' \}|

            )->open( `headerToolbar`
                )->open( `Toolbar`
                    )->open( `content`
                        )->leaf( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->leaf( `ToolbarSpacer`

                        )->open( `ComboBox`
                            )->a( n = `id`          v = `idPopinLayout`
                            )->a( n = `placeholder` v = `Popin layout options`
                            " original change handler dropped - the two-way selectedKey feeds the popinLayout expression binding
                            )->a( n = `selectedKey` v = client->_bind( popin_layout )

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
                    )->shut(
                )->shut(
            )->shut(
            )->open( `columns`
                )->open( `Column`
                    )->a( n = `width` v = `12em`

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
                    )->a( n = `type`  v = `Navigation`
                    )->a( n = `press` v = client->_event( `MESSAGE_DIALOG_PRESS` )

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
                            )->a( n = `state`  v = `{ parts: [{path: 'WEIGHT_MEASURE'}, {path: 'WEIGHT_UNIT'}], formatter: 'Formatter.weightState' }`
                        )->leaf( `ObjectNumber`
                            )->a( n = `number` v = `{ parts: [{path: 'PRICE'}, {path: 'CURRENCY_CODE'}], type: 'sap.ui.model.type.Currency', formatOptions: {showMeasure: false} }`
                            )->a( n = `unit`   v = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `MESSAGE_DIALOG_PRESS`.
        popup_message_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_message_display.

    " the controller-built message Dialog, shown as a popup fragment
    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Dialog`
            )->a( n = `title` v = `Message`
            )->a( n = `type`  v = `Message`

            )->open( `content`
                )->leaf( `Text`
                    )->a( n = `text` v = `Success`

            )->shut(
            )->open( `beginButton`
                )->leaf( `Button`
                    )->a( n = `text`  v = `OK`
                    )->a( n = `press` v = client->_event_client( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
