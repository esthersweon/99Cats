module CatsHelper
  def cat_sex_selected(cat, value)
    if cat.sex == value
      ' checked="checked"'
    else
      ''
    end
  end
end
