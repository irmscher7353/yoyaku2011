# coding: utf-8
# vim:sw=2:ts=2
class NamesController < ApplicationController
  # GET /names
  # GET /names.json
  def index
		if params[:all]
    	@names = Name.all
		else
			@names = Name.where(["mei = ''"]).order('id DESC')
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @names }
    end
  end

  # GET /names/1
  # GET /names/1.json
  def show
    @name = Name.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @name }
    end
  end

  # GET /names/new
  # GET /names/new.json
  def new
    @name = Name.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @name }
    end
  end

  # GET /names/1/edit
  def edit
    @name = Name.find(params[:id])
  end

  # POST /names
  # POST /names.json
  def create
    @name = Name.new(params[:name])

    respond_to do |format|
      if @name.save
        format.html { redirect_to @name, notice: 'Name was successfully created.' }
        format.json { render json: @name, status: :created, location: @name }
      else
        format.html { render action: "new" }
        format.json { render json: @name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /names/1
  # PUT /names/1.json
  def update
    @name = Name.find(params[:id])

		if params[:index]
			n = @name.sei.length
			i = params[:index].to_i
			if i < n
				params[:name][:mei] = params[:name][:sei][i .. n]
				params[:name][:sei] = params[:name][:sei][0 .. i-1]
			end
		end

    respond_to do |format|
      if @name.update_attributes(params[:name])
        format.html { redirect_to @name, notice: 'Name was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @name.errors, status: :unprocessable_entity }
      end
    end
  end

	# DELETE /names/1
	# DELETE /names/1.json
	def destroy
		@name = Name.find(params[:id])
		@name.destroy

		respond_to do |format|
			format.html { redirect_to names_url }
			format.json { head :ok }
		end
	end

	# PUT /names/absorb
	def absorb

		for order in Order.all
			f = order.name.split("　")
			if f.length == 2
				name = Name.new(:sei => f[0], :mei => f[1] )
			else
				name = Name.new(:sei => order.name, :mei => "" )
			end
			name.save
		end

		respond_to do |format|
			format.html { redirect_to :action => :index }
		end
	end

	# DELETE
	def delete_all

		Name.delete_all

		respond_to do |format|
			format.html { redirect_to :action => :index }
		end
	end

	# GET /names/export
	# GET /names/export.json
	def export

		name_list = []
		for name in Name.all
			name_list << [name.sei, name.mei ]
		end

		File.open('tmp/names.yml', 'w') {|f|
			f.write YAML.dump(name_list)
		}

		respond_to do |format|
			format.html { redirect_to :action => :index }
			format.json { render json: @orders }
		end
	end

	# PUT /names/import
	# PUT /names/import.json
	def import

		name_list = []
		File.open('tmp/names.yml', 'r') {|f|
			name_list = YAML.load(f.read)
		}

		for seimei in name_list
			name = Name.new(:sei => seimei[0], :mei => seimei[1] )
			name.save
		end

		respond_to do |format|
			format.html { redirect_to :action => :index }
			format.json { render json: @orders }
		end
	end

end
