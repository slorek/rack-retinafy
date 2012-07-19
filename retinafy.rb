class Retinafy
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    request.cookies['device_pixel_ratio'] ||= 1
    
    target_ratio = request.cookies['device_pixel_ratio'].to_i <= 1 ? 1 : 2
    
    original_path = env['PATH_INFO']
    env['PATH_INFO'] = original_path.gsub(/(png|jpg|gif)\Z/, target_ratio.to_s + 'x.\1')
    
    status, headers, response = @app.call(env)
    
    if status == 404
      env['PATH_INFO'] = original_path
      status, headers, response = @app.call(env)
    end
    
    [status,headers,response]
  end
end