class ToggleController < ApplicationController
  def index
      toggles = RemoteToggle.enabled_toggles(key: 'ACT-123')
      render json: toggles.to_json
  end

  def check_toggle
    resp = RemoteToggle.on?(params[:toggle_name], {key: 'ACT-123'})
    render json: {toggle: resp ? 'ON' : 'OFF'}
  end
end