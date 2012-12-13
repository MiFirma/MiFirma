class ActiveRecord::Base

  def self.relationship_with(model)
    association = reflect_on_association(model.table_name.to_sym) ||
                  reflect_on_association(model.model_name.underscore.to_sym)
    association.macro
  end

  #--
  # On a model:
  #
  #     class Post < ActiveRecord::Base
  #       STATUS = {  t("Published") => "published",
  #                   t("Pending") => "pending",
  #                   t("Draft") => "draft" }
  #     end
  #
  #     >> Post.first.status
  #     => "published"
  #     >> Post.first.mapping(:status)
  #     => "Published"
  #     >> I18n.locale = :es
  #     => :es
  #     >> Post.first.mapping(:status)
  #     => "Publicado"
  #++
  def mapping(attribute)
    values = self.class::const_get(attribute.to_s.upcase).to_a
    array = values.first.is_a?(Array) ? values : values.map { |i| [i, i] }

    value = array.rassoc(send(attribute))
    value ? value.first : send(attribute)
  end

  def to_label
    if respond_to?(:name) && send(:name).present?
      send(:name)
    else
      [self.class, id].join("#")
    end
  end

end
