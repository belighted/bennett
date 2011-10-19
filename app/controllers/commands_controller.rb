class CommandsController < ApplicationController
  before_filter :find_project
  
  # GET /commands/new
  # GET /commands/new.json
  def new
    @command = Command.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @command }
    end
  end

  # GET /commands/1/edit
  def edit
    @command = Command.find(params[:id])
  end

  # POST /commands
  # POST /commands.json
  def create
    @command = @project.commands.new(params[:command])

    respond_to do |format|
      if @command.save
        format.html { redirect_to @project, notice: 'Command was successfully created.' }
        format.json { render json: @command, status: :created, location: @command }
      else
        format.html { render action: "new" }
        format.json { render json: @command.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /commands/1
  # PUT /commands/1.json
  def update
    @command = Command.find(params[:id])

    respond_to do |format|
      if @command.update_attributes(params[:command])
        format.html { redirect_to @project, notice: 'Command was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @command.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commands/1
  # DELETE /commands/1.json
  def destroy
    @command = Command.find(params[:id])
    @command.destroy

    respond_to do |format|
      format.html { redirect_to @project }
      format.json { head :ok }
    end
  end
  
  def find_project
    @project = Project.find(params[:project_id])
  end
end
