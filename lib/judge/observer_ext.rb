include 'observer'
include 'weakref'

module Observable
  class WeakObserver < WeakRef
    def initialize(owner, obj)
      super(obj)
      @owner = owner
    end
    
    def update(*args)
      if weakref_alive?
        obj.update(*args)
      else
        @owner.delete_observer(self)
      end
    end
  end
  
  def add_weak_observer(observer)
    add_observer(WeakObserver.new(self, observer))
  end
end

class Proc
  def update(*args)
    call(*args)
  end
end