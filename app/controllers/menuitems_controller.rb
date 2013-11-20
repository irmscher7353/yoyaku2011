class MenuitemsController < ApplicationController
  # GET /menuitems
  # GET /menuitems.json
  def index
		if params[:release_id] and params[:release_id] != ""
			@menuitems = Menuiem.find_by_release(params[:release_id])
		else
    	@menuitems = Menuitem.all
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @menuitems }
    end
  end

	def index_tbody
		if params[:release_id] and params[:release_id] != ""
			@menuitems = Menuitem.find_by_release(params[:release_id])
		else
    	@menuitems = Menuitem.all
		end

		render partial: 'index_tbody'
	end

  # GET /menuitems/1
  # GET /menuitems/1.json
  def show
    @menuitem = Menuitem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @menuitem }
    end
  end

  # GET /menuitems/new
  # GET /menuitems/new.json
  def new
    @menuitem = Menuitem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @menuitem }
    end
  end

  # GET /menuitems/1/edit
  def edit
    @menuitem = Menuitem.find(params[:id])
  end

  # POST /menuitems
  # POST /menuitems.json
  def create
    @menuitem = Menuitem.new(params[:menuitem])

    respond_to do |format|
      if @menuitem.save
        format.html { redirect_to @menuitem, notice: 'Menuitem was successfully created.' }
        format.json { render json: @menuitem, status: :created, location: @menuitem }
      else
        format.html { render action: "new" }
        format.json { render json: @menuitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /menuitems/1
  # PUT /menuitems/1.json
  def update
    @menuitem = Menuitem.find(params[:id])

    respond_to do |format|
      if @menuitem.update_attributes(params[:menuitem])
        format.html { redirect_to @menuitem, notice: 'Menuitem was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @menuitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menuitems/1
  # DELETE /menuitems/1.json
  def destroy
    @menuitem = Menuitem.find(params[:id])
    @menuitem.destroy

    respond_to do |format|
      format.html { redirect_to menuitems_url }
      format.json { head :ok }
    end
  end
end
