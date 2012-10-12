ActiveAdmin.register Post do
  form do |f|
    f.inputs "Details" do
      f.input :title
    end
    f.inputs "Content" do
      f.input :body
    end
    f.inputs "Illustration" do
      f.file_field :illustration
    end
    f.buttons
  end
end
