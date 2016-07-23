class ClientsController < ApplicationController
  # Use a different layout
  layout 'appartements'
  # GET /clients
  # GET /clients.xml

 

  def index
    @clients = Client.find(:all , :order => 'nom')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clients }
    end
  end
 
  

  # GET /clients/1
  # GET /clients/1.xml
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.xml
  def new
    @client = Client.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @client }
    end
  end


  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])

  end

  # POST /clients
  # POST /clients.xml
  def create
    @client = Client.new(params[:client])
    @client.nom.strip!
    @client.nom.capitalize!
    respond_to do |format|
      if @client.save
        flash[:notice] = 'Client was successfully created.'
        format.html { redirect_to(@client) }
        format.xml  { render :xml => @client, :status => :created, :location => @client }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end



  def new_reserv
    @client = Client.new
    # positionement du flag pour signaler un nouveau client (id de l'appartement pour lequel le client est créer   
    @client.nouveau = params[:id]
  end

 def create_reserv
    @client = Client.new(params[:client])
    @client.nom.strip!
    @client.nom.capitalize!
     respond_to do |format|
      if @client.save
        flash[:notice] = 'Client was successfully created.'
        format.html { redirect_to(:controller => "reservations" , :action => "new", :id => @client.nouveau) }
        format.xml  { render :xml => @client, :status => :created, :location => @client }
      else
        format.html { render :action => "new_reserv" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.xml
  def update
    @client = Client.find(params[:id])
    cl = params[:client]
    nom = cl["nom"]
    nom.strip!
    nom.capitalize!
    params[:client][:nom] = nom
    respond_to do |format|
      if @client.update_attributes(params[:client])
        flash[:notice] = 'Client was successfully updated.'
        format.html { redirect_to(@client) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.xml
  def destroy
    @client = Client.find(params[:id])
#    @client.reservations.destroy
    @client.destroy

    respond_to do |format|
      format.html { redirect_to(clients_url) }
      format.xml  { head :ok }
    end
  end
end

public  
#fonction reinitialisant le flag nouveau pour tous les clients
def reinit
     @clients = Client.find(:all , :conditions =>{:nouveau =>  1..1000})
     for c in @clients
       c.nouveau = 0
       c.save
  end
     
end