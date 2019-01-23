class NotificationBuildController < ApplicationController
  include Wicked::Wizard

  steps :add_product_name, :add_external_reference, :single_or_multi_component

  before_action :set_notification

  def show
    render_wizard
  end

  def update
    if step == :single_or_multi_component
      if params[:single_or_multi_component] == 'single'
        @notification.components.build
        @notification.save
        redirect_to new_component_build_path(@notification.components.first)
      elsif params[:single_or_multi_component] == 'multiple'
        # TODO COSBETA-10 Implement multiple components
        @notification.components.build
        render_wizard @notification
      else
        render step
      end
    else
      @notification.update(notification_params)
      render_wizard @notification
    end    
  end

  def new
    redirect_to wizard_path(steps.first, notification_id: @notification.id)
  end

  def finish_wizard_path
    edit_notification_path(@notification)
  end

private

  def notification_params
    params.require(:notification).permit(:product_name, :external_reference)
  end

  def set_notification
    @notification = Notification.find(params[:notification_id])
  end
end
