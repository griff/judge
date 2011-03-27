require 'datc_test_case'

class Test6ABasicChecks < DatcTestCase
  def test_6a1_move_to_not_neighbour
    @game.units('England').build_fleet('North Sea')
    order = @game.orders('England').fleet('North Sea') >> 'Picardy'

    @game.resolve_orders
    
    assert_true order.invalid?
  end
  
  def test_6a2_move_army_to_sea
    @game.units('England').build_army('Liverpool')
    order = @game.orders('England').army('Liverpool') >> 'Irish Sea'

    @game.resolve_orders
    
    assert_true order.invalid?
  end
  
  def test_6a3_move_fleet_to_sea
    @game.units('Germany').build_fleet('Kiel')
    order = @game.orders('Germany').fleet('Kiel') >> 'Munich'

    @game.resolve_orders
    
    assert_true order.invalid?
  end
end