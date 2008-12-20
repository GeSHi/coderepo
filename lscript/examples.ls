@version 1.00
@warnings
@script modeler
@name "examples"

@define SCRIPT_NAME    "examples"
@define SCRIPT_VERSION "1.0"


/*
multi
line
comment
*/


// single line comment


main{
	selmode(DIRECT);
	editbegin();
		(count) = polycount();
		
		if (count < 1){
			error ("You must select at least one poly.");
			return;
		}
	editend();
	
	copy();
	lyrsetfg(NextFree);
	paste();

	reqbegin("Example controls");
	reqsize(291,200);

	c0 = ctltab("tab 1","tab 2");
	ctlposition(c0,0,0);

	c1 = ctlminislider("Minislider",copyframe,Scene().previewstart,Scene().previewend);
	ctlposition(c1, x1+100, y); y+=dy;

	c2 = ctldistance("Distance",dist);
	ctlposition(c2,49,40);

	ctlpage(1,c1);
	ctlpage(2,c2);

	ctlrefresh(c2,"SomeFunction"); //refresh active layer on ctrl update

	if (!reqpost()){
		selmode(GLOBAL);
		delete();
		lyrsetfg(OriginalLayer);
		return;
	}

    reqend();
}


saveObjectList: list, target{
    if (!list)
        return;

    for (loop = 1; loop <= list.size(); loop++){
        if (!list[loop].null){
            obSplit = pssplit(list[loop].filename);
            obTarget = target + bSlash + obSplit[3] + obSplit[4];
            if (obTarget != list[loop].filename){
                SelectItem(list[loop].id);
                SaveObject(obTarget);
                
                progress = round( loop/list.size(), 2);
                if (progress < 1)
                    StatusMsg("{" + progress.asStr() + "} Saving object " + list[loop].name );
                else
                    StatusMsg("Objects saved");
            }
        }
    }
}


FunctionA:val{
	undo();
	FunctionB();
}


FunctionB{
	editbegin();
		addpoint(0,0,0);
	editend();
}


AdjustdistHack:val{
	setvalue(c2,val*0.01);
}

SelectItem(mysourceid.asInt());
mysource = Scene().firstSelect();
mygroup = ChannelGroup(mysource.name);


getpos = bonegroups[group][endj].getPosition(0);
getrot = bonegroups[group][endj].getRotation(0);
rest = bonegroups[group][endj].restParam("POSITION");


somedata = recall("example",1);


prevstart=Scene().previewstart;
prevend=Scene().previewend;


if(!example){
	SelectItem(myitems[1].id);
	
	for(i=2;i<=myitems.size();i++)
		AddToSelection(myitems[i].id);
	error("Error");
}


replaceImages: master, new{
    for (loop = 1; loop <= master.size(); loop++)
    {
		master[loop].replace(new[loop]);
    }
}


ctl[SAVE_CTL].active(false);
ctl[BAKE_CTL].active(false);


if(a == "b"){
	a = cf.read().asNum();
	b = cf.read().asInt();
	c = cf.read();
}