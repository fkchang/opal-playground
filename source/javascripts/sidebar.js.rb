# Sidebar abstraction
class Sidebar
  attr_reader :element_id
  def initialize(element_id, side)
    @element_id = element_id
    @state = :closed
    set_params_for_side(side)
    Element.find("#{element_id} .toggles").on :click do
      toggle
    end
  end

  def toggle
    if @state == :open
      close
    else
      open
    end
  end

  attr_reader :closed_icon_class, :opened_icon_class,
              :opened_x_position, :closed_x_position,
              :x_position_side
  def set_params_for_side(side)
    if side == :left
      @closed_icon_class = 'glyphicon-chevron-right'
      @opened_icon_class = 'glyphicon-chevron-left'
      @opened_x_position = 20
      @closed_x_position = -180
      @x_position_side = 'left'
    else
      @closed_icon_class = 'glyphicon-chevron-left'
      @opened_icon_class = 'glyphicon-chevron-right'
      @opened_x_position = 20
      @closed_x_position = -780
      @x_position_side = 'right'
    end
  end

  def open
    new_state(opened_icon_class, closed_icon_class, opened_x_position, :open)
  end

  def new_state(class_to_add, class_to_remove, new_position, new_state)
    icon = Element.find("#{element_id} i")
    icon.add_class(class_to_add)
    icon.remove_class(class_to_remove)
    Element.find("#{element_id}").animate x_position_side => new_position
    @state = new_state
  end

  def close
    new_state(closed_icon_class, opened_icon_class, closed_x_position, :closed)
  end
end
