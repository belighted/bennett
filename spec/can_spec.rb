module CanSpec
  def can_spec(model, abilities, opts={})
    nested = [(opts[:nested_in] || [])].flatten.push(model)
    nested.each do |m|
      m.to_s.camelize.constantize rescue raise "Missing model #{m.to_s.camelize}"
    end
    model_class = model.to_s.camelize.constantize
    first_parent_class = nested.first.to_s.camelize.constantize

    all_methods = opts[:methods] || [:index, :new, :create, :show, :edit, :update, :destroy]

    abilities.each do |role, methods|
      all_methods.each do |method|
        authorized = methods.include?(method)
        it "#{authorized ? 'accepts' : 'rejects'} #{method} from #{role}" do
          user = FactoryGirl.create(role)
          nested_objects = nested.inject({}) do |h, current|
            parent = nested.index(current)==0 ? nil : nested[nested.index(current)-1]
            parent_object = h[parent] || user
            h.merge({ current => (parent_object.send(current) rescue parent_object.send("#{current.to_s.pluralize}").last rescue FactoryGirl.create(current, parent.nil? ? {} : {parent => parent_object})) || FactoryGirl.create(current, parent.nil? ? {} : {parent => parent_object}) })
          end
          object = nested_objects[model]
          new_object = nested.many? ? FactoryGirl.build(model, nested[-2] => nested_objects[nested[-2]]) : FactoryGirl.build(model)
          first_parent_object = nested_objects[nested.first]
          nested_params = nested_objects.inject({}) do |h, keyvalue|
            h.merge({"#{keyvalue.first}_id" => keyvalue.last.id})
          end
          bad_redirect = opts[:redirect_url] || root_url
          sign_in user
          case method
          when :index, :new
            get method, nested_params
            response.should(authorized ? be_success : redirect_to(bad_redirect))
          when :show, :edit
            get method, nested_params.merge(id: object.id)
            response.should(authorized ? be_success : redirect_to(bad_redirect))
          when :create
            lambda do
              post method, nested_params.merge(model => new_object.serializable_hash)
              success_redirect = nested.many? ? first_parent_object : first_parent_class.last
              response.should(authorized ? redirect_to(success_redirect) : redirect_to(bad_redirect))
            end.should change(model_class, :count).by(authorized ? 1 : 0)
          when :update
            put method, nested_params.merge(id: object.id, model => {})
            success_redirect = first_parent_object
            response.should(authorized ? redirect_to(success_redirect) : redirect_to(bad_redirect))
          when :destroy
            lambda do
              delete 'destroy', nested_params.merge(id: object.id)
              success_redirect = nested.many? ? first_parent_object : send("#{model.to_s.pluralize}_url")
              response.should redirect_to(authorized ? success_redirect : bad_redirect)
            end.should change(model_class, :count).by(authorized ? -1 : 0)
          end
        end
      end
    end
  end
end
