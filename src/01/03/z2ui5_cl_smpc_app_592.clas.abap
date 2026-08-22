" @keywords objectpagelayout object layout sap.uxap objectpagelazyloadingwithoutblocks objectpagedynamicheadertitle objectpagesection objectpagesubsection objectpagelazyloader
" @summary This sample showcases the lazy loading using the stashed property of the ObjectPageLazyLoader. It enables usage of lazy loading without the need to have Blocks
CLASS z2ui5_cl_smpc_app_592 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the view's bindElement( '/SupplierCollection/0' ) folded onto root fields
    DATA supplier_name TYPE string.
    DATA street        TYPE string.
    DATA housenumber   TYPE string.
    DATA zipcode       TYPE string.
    DATA city          TYPE string.
    DATA country       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_592 IMPLEMENTATION.

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

    " twenty-one identical sections, each a stashed ObjectPageLazyLoader around the
    " same Address form - which is the sample: lazy loading WITHOUT custom blocks
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.uxap`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `xmlns:f`   v = `sap.ui.layout.form`

        )->ele( `ObjectPageLayout`
            )->a( n = `id`                 v = `ObjectPageLayout`
            )->a( n = `enableLazyLoading`  v = `true`
            )->a( n = `upperCaseAnchorBar` v = `false`

            )->ele( `headerTitle`
                )->ele( `ObjectPageDynamicHeaderTitle`
                    )->ele( `heading`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `ObjectPage with LazyLoading without the use of Blocks`
                    )->end(

                    )->ele( `snappedTitleOnMobile`
                        )->tag( n = `Title` ns = `m`
                            )->a( n = `text` v = `ObjectPage with LazyLoading without the use of Blocks`
                    )->end(

                    )->ele( `actions`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `type` v = `Emphasized`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Delete`
                        )->tag( n = `Button` ns = `m`
                            )->a( n = `type` v = `Transparent`
                            )->a( n = `text` v = `Copy`
                        )->tag( n = `OverflowToolbarButton` ns = `m`
                            )->a( n = `icon`    v = `sap-icon://action`
                            )->a( n = `type`    v = `Transparent`
                            )->a( n = `text`    v = `Share`
                            )->a( n = `tooltip` v = `action`
                    )->end(
                )->end(
            )->end(

            )->ele( `sections`

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 1`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section1`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section1stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 2`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section2`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section2stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 3`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section3`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section3stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 4`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section4`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section4stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 5`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section5`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section5stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 6`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section6`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section6stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 7`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section7`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section7stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 8`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section8`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section8stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 9`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section9`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section9stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 10`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section10`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section10stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 11`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section11`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section11stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 12`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section12`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section12stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 13`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section13`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section13stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 14`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section14`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section14stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 15`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section15`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section15stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 16`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section16`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section16stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 17`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section17`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section17stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 18`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section18`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section18stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 19`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section19`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section19stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 20`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section20`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section20stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `ObjectPageSection`
                    )->a( n = `titleUppercase` v = `false`
                    )->a( n = `title`          v = `my section`
                    )->ele( `subSections`
                        )->ele( `ObjectPageSubSection`
                            )->a( n = `title`          v = `Section 21`
                            )->a( n = `mode`           v = `Expanded`
                            )->a( n = `id`             v = `Section21`
                            )->a( n = `titleUppercase` v = `false`
                            )->ele( `blocks`
                                )->ele( `ObjectPageLazyLoader`
                                    )->a( n = `stashed` v = `true`
                                    )->a( n = `id`      v = `Section21stashed`

                                    )->ele( n = `VBox` ns = `m`
                                        )->a( n = `class` v = `sapUiSmallMargin`
                                        )->ele( n = `SimpleForm` ns = `f`
                                            )->a( n = `maxContainerCols` v = `2`
                                            )->a( n = `editable`         v = `false`
                                            )->a( n = `layout`           v = `ResponsiveGridLayout`
                                            )->a( n = `title`            v = `Address`
                                            )->a( n = `labelSpanL`       v = `3`
                                            )->a( n = `labelSpanM`       v = `3`
                                            )->a( n = `emptySpanL`       v = `4`
                                            )->a( n = `emptySpanM`       v = `4`
                                            )->a( n = `columnsL`         v = `1`
                                            )->a( n = `columnsM`         v = `1`
                                            )->a( n = `width`            v = `auto`
                                            )->a( n = `class`            v = `sapUxAPObjectPageSubSectionAlignContent`

                                            )->ele( n = `content` ns = `f`
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Name`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( supplier_name )
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Street/No.`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{STREET\} \{HOUSENUMBER\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `ZIP Code/City`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = |\{ZIPCODE\} \{CITY\}|
                                                )->tag( n = `Label` ns = `m`
                                                    )->a( n = `text` v = `Country`
                                                )->tag( n = `Text` ns = `m`
                                                    )->a( n = `text` v = client->_bind( country )
                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " sap/ui/demo/mock/supplier.json /SupplierCollection/0, the row the view
    " binds with bindElement
    supplier_name = `Red Point Stores`.
    street        = `Main St`.
    housenumber   = `1618`.
    zipcode       = `31415`.
    city          = `Maintown`.
    country       = `Germany`.

  ENDMETHOD.

ENDCLASS.
