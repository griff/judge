error_map 'empty', MissingPowerError, ''

error_map 'incomplete_location_1', InvalidLocationError, <<_END_
  ENGLAND BUL
  DENMARK
_END_

error_map 'incomplete_location_2', InvalidLocationError, <<_END_
  LAND BUL

  ENGLAND
  DENMARK
_END_

error_map 'incomplete_location_3', InvalidLocationError, <<_END_
  Bulgaria               = bul

  ENGLAND
  DENMARK
_END_
  
#error_map 'dummy_before_power', DPJudgeNoCurrentPower, <<_END_
#  DUMMY

#  ENGLAND
#  DENMARK
#_END_

#error_map 'militia_before_power', DPJudgeNoCurrentPower, <<_END_
#  MILITIA 5

#  ENGLAND
#  DENMARK
#_END_

error_map 'owns_before_power', DPJudgeNoCurrentPower, <<_END_
  OWNS

  ENGLAND
  DENMARK
_END_

#error_map 'reserves_before_power', DPJudgeNoCurrentPower, <<_END_
#  RESERVES 5

#  ENGLAND
#  DENMARK
#_END_

error_map 'unit_before_power', DPJudgeNoCurrentPower, <<_END_
  Bulgaria               = bul
  LAND BUL

  A BUL

  ENGLAND
  DENMARK
_END_

error_map 'units_before_power', DPJudgeNoCurrentPower, <<_END_
  UNITS

  ENGLAND
  DENMARK
_END_

error_map 'factory_and_neutral', AlreadyFactoryError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND +BUL
  NEUTRAL BUL

  DENMARK
_END_

error_map 'factory_and_owns', AlreadyFactoryError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND +BUL
  OWNS BUL

  DENMARK
_END_

error_map 'factory_and_home', AlreadyFactoryError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND +BUL BUL

  DENMARK
_END_

error_map 'factory_and_home_two_lines', AlreadyFactoryError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND +BUL
  ENGLAND BUL

  DENMARK
_END_

error_map 'factory_and_neutral_reverse', AlreadySupplyCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  DENMARK
  NEUTRAL BUL

  ENGLAND +BUL
_END_

error_map 'factory_and_owns_reverse', AlreadySupplyCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  DENMARK
  OWNS BUL

  ENGLAND +BUL
_END_

error_map 'factory_and_home_reverse', AlreadySupplyCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND BUL +BUL

  DENMARK
_END_

error_map 'factory_and_home_two_lines_reverse', AlreadySupplyCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND BUL
  ENGLAND +BUL

  DENMARK
_END_

error_map 'partisan_and_neutral', AlreadyPartisanError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND *BUL
  NEUTRAL BUL

  DENMARK
_END_

error_map 'partisan_and_owns', AlreadyPartisanError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND *BUL
  OWNS BUL

  DENMARK
_END_

error_map 'partisan_and_home', AlreadyPartisanError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND *BUL BUL

  DENMARK
_END_

error_map 'partisan_and_home_two_lines', AlreadyPartisanError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND *BUL
  ENGLAND BUL

  DENMARK
_END_

error_map 'partisan_and_neutral_reverse', AlreadySupplyCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  DENMARK
  NEUTRAL BUL

  ENGLAND *BUL
_END_

error_map 'partisan_and_owns_reverse', AlreadySupplyCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  DENMARK
  OWNS BUL

  ENGLAND *BUL
_END_

error_map 'partisan_and_home_reverse', AlreadySupplyCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND BUL *BUL

  DENMARK
_END_

error_map 'partisan_and_home_two_lines_reverse', AlreadySupplyCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND BUL
  ENGLAND *BUL

  DENMARK
_END_

error_map 'no_powers', MissingPowerError, <<_END_
  Bulgaria               = bul
  LAND BUL
_END_

error_map 'only_powers', MissingLocationsError, <<_END_
  ENGLAND
  DENMARK
_END_

error_map 'same_home_twice', AlreadyHomeCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND BUL BUL

  DENMARK
_END_

error_map 'same_home_twice_two_lines', AlreadyHomeCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND BUL
  ENGLAND BUL

  DENMARK
_END_

error_map 'same_owner_twice', AlreadyOwnedCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND
  OWNS BUL BUL

  DENMARK
_END_

error_map 'same_owner_twice_two_lines', AlreadyOwnedCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND
  OWNS BUL
  owns BUL

  DENMARK
_END_

error_map 'same_province_abbreviation', DPJudgeProvinceRedefinitionError, <<_END_
  Bulgaria               = bul
  Bullfighter            = bul
  LAND BUL

  ENGLAND
  DENMARK
_END_

error_map 'two_homes', AlreadyHomeCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND BUL
  DENMARK BUL
_END_

error_map 'two_owners', AlreadyOwnedCenterError, <<_END_
  Bulgaria               = bul
  LAND BUL

  ENGLAND
  OWNS BUL

  DENMARK
  OWNS BUL
_END_

error_map 'rename_undefined', InvalidLocationError, <<_END_
  arm -> Bulgaria               = bul
  LAND ARM

  ENGLAND
  DENMARK
_END_

error_map_file 'use_loop_1', DPJudgeLoadLoopDetectedError
error_map_file 'use_loop_self', DPJudgeLoadLoopDetectedError