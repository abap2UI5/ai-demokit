CLASS z2ui5_cl_api_app_423 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_country,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_country.
    DATA t_countries TYPE STANDARD TABLE OF ty_s_country WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_423 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " Data of the mock model sap/ui/demo/mock/countriesExtendedCollection.json used by the original sample
    DATA temp1 LIKE t_countries.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-key = `DZ`.
    temp2-text = `Algeria`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `AR`.
    temp2-text = `Argentina`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `AU`.
    temp2-text = `Australia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `AT`.
    temp2-text = `Austria`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `BH`.
    temp2-text = `Bahrain`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `BE`.
    temp2-text = `Belgium`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `BA`.
    temp2-text = `Bosnia and Herzegovina`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `BR`.
    temp2-text = `Brazil`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `BG`.
    temp2-text = `Bulgaria`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `CA`.
    temp2-text = `Canada`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `CL`.
    temp2-text = `Chile`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `CO`.
    temp2-text = `Colombia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `HR`.
    temp2-text = `Croatia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `CU`.
    temp2-text = `Cuba`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `CZ`.
    temp2-text = `Czech Republic`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `DK`.
    temp2-text = `Denmark`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `EG`.
    temp2-text = `Egypt`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `EE`.
    temp2-text = `Estonia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `FI`.
    temp2-text = `Finland`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `FR`.
    temp2-text = `France`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `GER`.
    temp2-text = `Germany`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `GH`.
    temp2-text = `Ghana`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `GR`.
    temp2-text = `Greece`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `HU`.
    temp2-text = `Hungary`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `IN`.
    temp2-text = `India`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `ID`.
    temp2-text = `Indonesia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `IE`.
    temp2-text = `Ireland`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `IL`.
    temp2-text = `Israel`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `IT`.
    temp2-text = `Italy`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `JP`.
    temp2-text = `Japan`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `JO`.
    temp2-text = `Jordan`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `KE`.
    temp2-text = `Kenya`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `KW`.
    temp2-text = `Kuwait`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `LV`.
    temp2-text = `Latvia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `LT`.
    temp2-text = `Lithuania`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `MK`.
    temp2-text = `Macedonia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `MY`.
    temp2-text = `Malaysia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `MX`.
    temp2-text = `Mexico`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `ME`.
    temp2-text = `Montenegro`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `MA`.
    temp2-text = `Morocco`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `NL`.
    temp2-text = `Netherlands`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `NZ`.
    temp2-text = `New Zealand`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `NG`.
    temp2-text = `Nigeria`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `NO`.
    temp2-text = `Norway`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `OM`.
    temp2-text = `Oman`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `PE`.
    temp2-text = `Peru`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `PH`.
    temp2-text = `Philippines`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `PL`.
    temp2-text = `Poland`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `PT`.
    temp2-text = `Portugal`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `QA`.
    temp2-text = `Qatar`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `RO`.
    temp2-text = `Romania`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `RU`.
    temp2-text = `Russia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `SA`.
    temp2-text = `Saudi Arabia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `SN`.
    temp2-text = `Senegal`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `RS`.
    temp2-text = `Serbia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `SG`.
    temp2-text = `Singapore`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `SK`.
    temp2-text = `Slovakia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `SI`.
    temp2-text = `Slovenia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `ZA`.
    temp2-text = `South Africa`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `KR`.
    temp2-text = `South Korea`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `ES`.
    temp2-text = `Spain`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `SE`.
    temp2-text = `Sweden`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `CH`.
    temp2-text = `Switzerland`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `TN`.
    temp2-text = `Tunisia`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `TR`.
    temp2-text = `Turkey`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `UG`.
    temp2-text = `Uganda`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `UA`.
    temp2-text = `Ukraine`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `AE`.
    temp2-text = `United Arab Emirates`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `GB`.
    temp2-text = `United Kingdom`.
    INSERT temp2 INTO TABLE temp1.
    temp2-key = `YE`.
    temp2-text = `Yemen`.
    INSERT temp2 INTO TABLE temp1.
    t_countries = temp1.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    view = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->open( `content`
                )->open( `ComboBox`
                    )->a( n = `items` v = |\{ path: '{ client->_bind_edit( val = t_countries path = abap_true ) }', sorter: \{ path: 'TEXT' \} \}|

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{KEY}`
                        )->a( n = `text` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
