resources :managements do
	get 'report' => :report, as: 'report', on: :member
	get 'export' => :export, as: 'export', on: :member
	get 'archive' => :archive, as: 'archive', on: :member
	get 'unarchive' => :unarchive, as: 'unarchive', on: :member
	get 'reset' => :reset, as: 'reset', on: :member
	get 'publish' => :publish, as: 'publish', on: :member
	get 'unpublish' => :unpublish, :as => 'unpublish', on: :member
	get 'duplicate' => :duplicate, :as => 'duplicate', on: :member
end
resources :surveys do
	get 'fill' => :fill, as: 'fill', on: :member
	put 'fill', to: 'answers#saveAnswers', on: :member
	get 'selfdelete' => :selfdelete, :as => 'selfdelete', on: :member
end