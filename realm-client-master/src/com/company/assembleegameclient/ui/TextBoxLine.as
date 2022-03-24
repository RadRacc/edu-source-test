package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.FameUtil;
   import flash.display.Sprite;
   import flash.text.engine.ContentElement;
   import flash.text.engine.ElementFormat;
   import flash.text.engine.GraphicElement;
   import flash.text.engine.GroupElement;
   import flash.text.engine.TextBlock;
   import flash.text.engine.TextElement;
   
   public class TextBoxLine
   {
      private static var ELEMENT_FORMATS:ElementFormats = new ElementFormats();

      public var time_:int;
      public var guild_:String;
      public var name_:String;
      public var rankIcon_:Sprite = null;
      public var recipient_:String;
      public var toMe_:Boolean;
      public var text_:String;
      
      public function TextBoxLine(time:int, guild:String, name:String, objectId:int, numStars:int, recipient:String, toMe:Boolean, text:String)
      {
         super();
         this.time_ = time;
         this.guild_ = guild;
         this.name_ = name;
         if(numStars >= 0)
         {
            this.rankIcon_ = FameUtil.numStarsToIcon(numStars);
         }
         this.recipient_ = recipient;
         this.toMe_ = toMe;
         this.text_ = text;
      }
      
      public function getTextBlock() : TextBlock
      {
         var vec:Vector.<ContentElement> = new Vector.<ContentElement>(0);
         var nameFormat:ElementFormat = ELEMENT_FORMATS.playerFormat_;
         var guildFormat:ElementFormat = nameFormat;
         var sepFormat:ElementFormat = ELEMENT_FORMATS.sepFormat_;
         var textFormat:ElementFormat = ELEMENT_FORMATS.normalFormat_;
         var name:String = this.name_;
         var guild:String = this.guild_;
         switch(this.name_)
         {
            case Parameters.SERVER_CHAT_NAME:
               name = "";
               guild = "";
               textFormat = ELEMENT_FORMATS.serverFormat_;
               break;
            case Parameters.CLIENT_CHAT_NAME:
               name = "";
               guild = "";
               textFormat = ELEMENT_FORMATS.clientFormat_;
               break;
            case Parameters.HELP_CHAT_NAME:
               name = "";
               guild = "";
               textFormat = ELEMENT_FORMATS.helpFormat_;
               break;
            case Parameters.ERROR_CHAT_NAME:
               textFormat = ELEMENT_FORMATS.errorFormat_;
               name = "";
               guild = "";
         }
         if(this.name_.charAt(0) == "#")
         {
            name = this.name_.substr(1);
            guild = "";
            nameFormat = ELEMENT_FORMATS.enemyFormat_;
         }
         if(this.name_.charAt(0) == "@")
         {
            name = this.name_.substr(1);
            guild = this.guild_;
            nameFormat = ELEMENT_FORMATS.adminFormat_;
            guildFormat = nameFormat;
            textFormat = ELEMENT_FORMATS.adminFormat_;
         }
         if(this.recipient_ == Parameters.GUILD_CHAT_NAME)
         {
            textFormat = ELEMENT_FORMATS.guildFormat_;
            guild = "";
         }
         else if(this.recipient_ != "")
         {
            textFormat = ELEMENT_FORMATS.tellFormat_;
            if(!this.toMe_)
            {
               vec.push(new TextElement("To: ",ELEMENT_FORMATS.normalFormat_));
               name = this.recipient_;
               guild = "";
               this.rankIcon_ = null;
            }
         }
         if(this.rankIcon_ != null)
         {
            this.rankIcon_.y = 3;
            vec.push(new GraphicElement(this.rankIcon_,this.rankIcon_.width + 2,this.rankIcon_.height,ELEMENT_FORMATS.normalFormat_));
         }
         if(guild != "")
         {
             vec.push(new TextElement("[" + guild + "]",guildFormat),new TextElement(" ",sepFormat));
         }
         if(name != "")
         {
            vec.push(new TextElement("<" + name + ">",nameFormat),new TextElement(" ",sepFormat));
         }
         vec.push(new TextElement(this.text_,textFormat));
         var groupElement:GroupElement = new GroupElement(vec);
         return new TextBlock(groupElement);
      }
   }
}
