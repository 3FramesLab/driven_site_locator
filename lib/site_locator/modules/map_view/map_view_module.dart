library map_view_module;

import 'dart:async';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:driven_common/common/driven_dimensions.dart';
import 'package:driven_common/globals.dart';
import 'package:driven_site_locator/config/site_locator_navigation.dart';
import 'package:driven_site_locator/config/site_locator_routes.dart';
import 'package:driven_site_locator/constants/api_constants.dart';
import 'package:driven_site_locator/constants/api_return_status.dart';
import 'package:driven_site_locator/constants/app_strings.dart';
import 'package:driven_site_locator/constants/internal_text.dart';
import 'package:driven_site_locator/data/auth/use_cases/extract_access_token_data_use_case.dart';
import 'package:driven_site_locator/data/model/app_utils.dart';
import 'package:driven_site_locator/data/model/entitlement_repository.dart';
import 'package:driven_site_locator/data/repositories/site_locator_repository_impl.dart';
import 'package:driven_site_locator/data/use_cases/base_future_usecase.dart';
import 'package:driven_site_locator/data/use_cases/base_usecase.dart';
import 'package:driven_site_locator/driven_components/driven_components.dart';
import 'package:driven_site_locator/driven_site_locator.dart';
import 'package:driven_site_locator/site_locator/configuration/site_locator_config.dart';
import 'package:driven_site_locator/site_locator/constants/semantic_strings.dart';
import 'package:driven_site_locator/site_locator/constants/site_location_info_view_modes.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_api_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_assets.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_constants.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_dimensions.dart';
import 'package:driven_site_locator/site_locator/constants/site_locator_route_arguments.dart';
import 'package:driven_site_locator/site_locator/controllers/fuel_price_disclaimer_controller.dart';
import 'package:driven_site_locator/site_locator/controllers/setup_wizard_controller.dart';
import 'package:driven_site_locator/site_locator/controllers/site_locator_token_controller.dart';
import 'package:driven_site_locator/site_locator/data/local/enhanced_filter/enhanced_filter_data.dart';
import 'package:driven_site_locator/site_locator/data/local/enhanced_filter/enhanced_filter_session_manager.dart';
import 'package:driven_site_locator/site_locator/data/models/diesel_price_entity.dart';
import 'package:driven_site_locator/site_locator/data/models/diesel_prices_pack.dart';
import 'package:driven_site_locator/site_locator/data/models/distance_matrix.dart';
import 'package:driven_site_locator/site_locator/data/models/enhanced_filter_model.dart';
import 'package:driven_site_locator/site_locator/data/models/fuel_preferences.dart';
import 'package:driven_site_locator/site_locator/data/models/fuel_prices.dart';
import 'package:driven_site_locator/site_locator/data/models/google_place_model.dart';
import 'package:driven_site_locator/site_locator/data/models/site_filter.dart';
import 'package:driven_site_locator/site_locator/data/models/site_location.dart';
import 'package:driven_site_locator/site_locator/data/services/site_locations_service.dart';
import 'package:driven_site_locator/site_locator/loading_progress_indicator/calculate_loading_progress_usecase.dart';
import 'package:driven_site_locator/site_locator/loading_progress_indicator/sites_loading_progress_controller.dart';
import 'package:driven_site_locator/site_locator/loading_progress_indicator/sites_loading_progress_props.dart';
import 'package:driven_site_locator/site_locator/loading_progress_indicator/widgets/sites_loading_progress_indicator.dart';
import 'package:driven_site_locator/site_locator/modules/cardholder_setup/cardholder_setup_module.dart';
import 'package:driven_site_locator/site_locator/modules/filters/filter_module.dart';
import 'package:driven_site_locator/site_locator/modules/location_cache/location_cache_module.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/use_cases/cache_fuel_price/get_sites_uncached_usecase.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/use_cases/cache_fuel_price/manage_cache_fuel_prices.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/use_cases/cache_fuel_price/model/cached_fuel_prices_store.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/use_cases/get_fuel_preferences_use_case.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/use_cases/get_selected_card_fuel_pref_type_use_case.dart';
import 'package:driven_site_locator/site_locator/modules/map_view/widgets/dialogs/enable_location_service_dialog.dart';
import 'package:driven_site_locator/site_locator/modules/search_locations/search_location_module.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/core/custom_pin_markers/custom_pin.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/core/custom_pin_markers/pin_variant_store.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/core/site_locator_map.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/models/site.dart';
import 'package:driven_site_locator/site_locator/site_locator_map/use_cases/compute_circle_radius_use_case.dart';
import 'package:driven_site_locator/site_locator/use_cases/access_token/get_access_token_for_sites_use_case.dart';
import 'package:driven_site_locator/site_locator/use_cases/common/get_string_list_from_sp_use_case.dart';
import 'package:driven_site_locator/site_locator/use_cases/common/store_string_list_into_sp_use_case.dart';
import 'package:driven_site_locator/site_locator/use_cases/diesel_prices/display_diesel_price_usecase.dart';
import 'package:driven_site_locator/site_locator/use_cases/diesel_prices/get_diesel_prices_pack_usecase.dart';
import 'package:driven_site_locator/site_locator/use_cases/diesel_prices/manage_diesel_sale_type_usecase.dart';
import 'package:driven_site_locator/site_locator/utilities/extensions/lat_lng_bounds_extension.dart';
import 'package:driven_site_locator/site_locator/utilities/map_utilities.dart';
import 'package:driven_site_locator/site_locator/utilities/math_utils.dart';
import 'package:driven_site_locator/site_locator/utilities/site_info_utils.dart';
import 'package:driven_site_locator/site_locator/utilities/site_locator_utils.dart';
import 'package:driven_site_locator/site_locator/views/map_view_page/widgets/menu/site_locator_menu_icon.dart';
import 'package:driven_site_locator/site_locator/views/map_view_page/widgets/menu/site_locator_menu_panel.dart';
import 'package:driven_site_locator/site_locator/views/setup_wizard/setup_wizard_sliding_panel.dart';
import 'package:driven_site_locator/site_locator/views/site_info_panel/site_info_sliding_panel.dart';
import 'package:driven_site_locator/site_locator/widgets/back_button.dart';
import 'package:driven_site_locator/site_locator/widgets/dialogs/change_filters_dialog.dart';
import 'package:driven_site_locator/site_locator/widgets/dialogs/enhanced_no_locations_dialog.dart';
import 'package:driven_site_locator/site_locator/widgets/dialogs/fuel_price_disclaimer_dialog.dart';
import 'package:driven_site_locator/site_locator/widgets/dialogs/no_locations_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps_cluster/flutter_google_maps_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

part 'controllers/site_locator_controller.dart';
part 'site_locator_state.dart';
part 'use_cases/apply_cluster_use_case.dart';
part 'use_cases/filter_markers_use_case.dart';
part 'use_cases/generate_markers_use_case.dart';
part 'use_cases/generate_site_hashmap_use_case.dart';
part 'use_cases/generate_site_location_hashmap_use_case.dart';
part 'use_cases/get_site_list_from_site_locations_use_case.dart';
part 'use_cases/get_tap_on_map_locations_message_use_case.dart';
part 'use_cases/get_user_location_use_case.dart';
part 'use_cases/get_welcome_screen_info_use_case.dart';
part 'use_cases/update_marker_icon_use_case.dart';
part 'use_cases/update_site_locations_fuel_prices_use_case.dart';
part 'views/site_locator_map_view_page.dart';
part 'widgets/floating_map_button.dart';
part 'widgets/floating_map_buttons_container.dart';
part 'widgets/gps_icon_button.dart';
part 'widgets/site_locator_map_ui.dart';
part 'widgets/welcome_map_view.dart';
